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

  create_archive = false

  attach_sqs_policy     = true
  attach_kinesis_policy = true

  sqs_target_arns     = [aws_sqs_queue.queue.arn]
  kinesis_target_arns = [aws_kinesis_stream.this.arn]

  archive_config = {
    description    = "some archive"
    retention_days = 1
    event_pattern  = <<PATTERN
    {
      "source": ["co.pmlo.netsuite"]
    }
    PATTERN
  }

  rules = {
    orders = {
      description   = "Capture all order data",
      event_pattern = jsonencode({ "source" : ["co.pmlo.netsuite"] })
      enabled       = false
    }
  }

  targets = {
    orders = [
      {
        name    = "send-orders-to-sqs",
        arn     = aws_sqs_queue.queue.arn
        dlq_arn = aws_sqs_queue.dlq.arn
      },
      {
        name              = "send-orders-to-kinesis",
        arn               = aws_kinesis_stream.this.arn
        dlq_arn           = aws_sqs_queue.dlq.arn,
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

resource "aws_dynamodb_table" "this" {
  name             = random_pet.this.id
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "UserId"
  range_key        = "GameTitle"
  stream_view_type = "NEW_AND_OLD_IMAGES"
  stream_enabled   = true

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }
}

resource "aws_kinesis_stream" "this" {
  name        = random_pet.this.id
  shard_count = 1
}
