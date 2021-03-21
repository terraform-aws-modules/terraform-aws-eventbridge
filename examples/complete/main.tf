terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws    = ">= 3.19"
    random = ">= 0"
  }
}

provider "aws" {
  region = "ap-southeast-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

resource "random_pet" "this" {
  length = 2
}

module "eventbridge" {
  source = "../../"

  bus_name = "${random_pet.this.id}-bus"

  create_bus         = true
  create_rule        = true
  create_targets     = true
  create_archives    = true
  create_permissions = true

  attach_tracing_policy          = true
  attach_kinesis_policy          = true
  attach_kinesis_firehose_policy = true
  attach_sqs_policy              = true
  attach_ecs_policy              = true
  attach_lambda_policy           = true
  attach_sfn_policy              = true
  attach_cloudwatch_policy       = true

  sqs_target_arns              = [aws_sqs_queue.queue.arn]
  ecs_target_arns              = []
  kinesis_target_arns          = [aws_kinesis_stream.this.arn]
  kinesis_firehose_target_arns = []
  lambda_target_arns           = []
  sfn_target_arns              = []
  cloudwatch_target_arns       = []

  permission_config = [
    {
      account_id   = "099720109477",
      statement_id = "canonical"
    },
    {
      account_id   = "099720109466",
      statement_id = "canonical_two"
    }
  ]

  archive_config = [
    {
      description    = "some archive"
      retention_days = 1
      event_pattern  = <<PATTERN
      {
        "source": ["co.pmlo.netsuite"]
      }
      PATTERN
    }
  ]

  rules = {
    orders = {
      description   = "Capture all order data"
      event_pattern = jsonencode({ "source" : ["co.pmlo.netsuite"] })
      enabled       = false
    }
  }

  targets = {
    orders = [
      {
        name            = "send-orders-to-sqs"
        arn             = aws_sqs_queue.queue.arn
        dead_letter_arn = aws_sqs_queue.dlq.arn
      },
      {
        name              = "send-orders-to-kinesis"
        arn               = aws_kinesis_stream.this.arn
        dead_letter_arn   = aws_sqs_queue.dlq.arn
        input_transformer = local.kinesis_input_transformer
      }
    ]
  }
   ######################
  # Additional policies
  ######################

  attach_policy_json = true
  policy_json        = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "xray:GetSamplingStatisticSummaries"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF

  attach_policy_jsons = true
  policy_jsons = [<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "xray:*"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
  ]
  number_of_policy_jsons = 1

  attach_policy = true
  policy        = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

  attach_policies    = true
  policies           = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]
  number_of_policies = 1

  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:BatchWriteItem"],
      resources = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
    },
    s3_read = {
      effect    = "Deny",
      actions   = ["s3:HeadObject", "s3:GetObject"],
      resources = ["arn:aws:s3:::my-bucket/*"]
    }
  }

  ###########################
  # END: Additional policies
  ###########################
}

locals {
  kinesis_input_transformer = {
    input_paths = {
      order_id = "$.detail.order_id"
    }
    input_template = <<EOF
    {
      "id": <order_id>
    }
    EOF
  }
}

resource "aws_kinesis_stream" "this" {
  name        = random_pet.this.id
  shard_count = 1
}

resource "aws_sqs_queue" "queue" {
  name = "${random_pet.this.id}-queue"
}

resource "aws_sqs_queue" "dlq" {
  name = "${random_pet.this.id}-dlq"
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id
  policy    = data.aws_iam_policy_document.queue.json
}

data "aws_iam_policy_document" "queue" {
  statement {
    sid     = "events-policy"
    actions = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [
      aws_sqs_queue.queue.arn,
      aws_sqs_queue.fifo.arn
    ]
  }
}

