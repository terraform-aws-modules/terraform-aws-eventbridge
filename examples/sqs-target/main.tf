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

module "eventbridge" {
  source = "../../"

  bus_name = "${random_pet.this.id}-bus"

  attach_sqs_policy = true
  sqs_target_arns = [
    aws_sqs_queue.queue.arn,
    aws_sqs_queue.fifo.arn,
    aws_sqs_queue.dlq.arn
  ]

  rules = {
    orders = {
      description   = "Capture all created orders",
      event_pattern = jsonencode({ "source" : ["orders.create"] })
    }
  }

  targets = {
    orders = [
      {
        name = "send-orders-to-sqs"
        arn  = aws_sqs_queue.queue.arn
      },
      {
        name            = "send-orders-to-sqs-wth-dead-letter"
        arn             = aws_sqs_queue.queue.arn
        dead_letter_arn = aws_sqs_queue.dlq.arn
      },
      {
        name            = "send-orders-to-sqs-with-retry-policy"
        arn             = aws_sqs_queue.queue.arn
        dead_letter_arn = aws_sqs_queue.dlq.arn
        retry_policy = {
          maximum_retry_attempts       = 10
          maximum_event_age_in_seconds = 300
        }
      },
      {
        name             = "send-orders-to-fifo-sqs"
        arn              = aws_sqs_queue.fifo.arn
        dead_letter_arn  = aws_sqs_queue.dlq.arn
        message_group_id = "send-orders-to-fifo-sqs"
      }
    ]
  }

  tags = {
    Name = "${random_pet.this.id}-bus"
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_sqs_queue" "queue" {
  name = random_pet.this.id
}

resource "aws_sqs_queue" "fifo" {
  name                        = "${random_pet.this.id}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
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

