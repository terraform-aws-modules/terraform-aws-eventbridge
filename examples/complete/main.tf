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

  create_archives = false

  attach_sqs_policy     = true
  attach_kinesis_policy = true

  sqs_target_arns     = [aws_sqs_queue.queue.arn]
  kinesis_target_arns = [aws_kinesis_stream.this.arn]

  archive_configs = [
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
        name       = "send-orders-to-sqs"
        arn        = aws_sqs_queue.queue.arn
        dlq_arn    = aws_sqs_queue.dlq.arn
      },
      {
        name              = "send-orders-to-kinesis"
        arn               = aws_kinesis_stream.this.arn
        dlq_arn           = aws_sqs_queue.dlq.arn
        input_transformer = local.kinesis_input_transformer
      }
    ]
  }
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

resource "aws_sqs_queue" "queue" {
  name = "${random_pet.this.id}-queue"
}

resource "aws_sqs_queue" "dlq" {
  name = "${random_pet.this.id}-dlq"
}

resource "aws_kinesis_stream" "this" {
  name        = random_pet.this.id
  shard_count = 1
}
