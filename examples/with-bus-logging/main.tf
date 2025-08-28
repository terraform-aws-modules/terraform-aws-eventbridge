provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

data "aws_caller_identity" "current" {}

module "eventbridge" {
  source = "../../"

  create_bus = true

  bus_name = "${random_pet.this.id}-bus"
  bus_log_config = {
    include_detail = "FULL"
    level          = "INFO"
    cloudwatch = {
      enabled       = true
      log_group_arn = module.cloudwatch_log_group.cloudwatch_log_group_arn
    }
    s3 = {
      enabled    = true
      bucket_arn = module.s3_bucket.s3_bucket_arn
    }
  }
}

#################
# Extra resources
#################

resource "random_pet" "this" {
  length = 2
}

######################
# CloudWatch Log Group
######################
module "cloudwatch_log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = "/aws/vendedlogs/events/event-bus/${random_pet.this.id}-bus"
  retention_in_days = 14
}

data "aws_iam_policy_document" "cwlogs" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${module.cloudwatch_log_group.arn}:log-stream:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        module.eventbridge.eventbridge_log_delivery_source.arn
      ]
    }
  }
}

####
# S3
####
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket        = "${random_pet.this.id}-eventbridge-bus-logs-bucket"
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  acl = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${module.s3_bucket.s3_bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/EventBusLogs/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        module.eventbridge.eventbridge_log_delivery_source.arn
      ]
    }
  }
}

#
# Kinesis Fire
#

