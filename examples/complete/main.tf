provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

module "eventbridge" {
  source = "../../"

  create_bus = false

  # Some targets are only working with the default bus, so we don't have to create a new one like this:
  # bus_name = "${random_pet.this.id}-bus"

  create_schemas_discoverer = true

  attach_tracing_policy = true

  attach_kinesis_policy = true
  kinesis_target_arns   = [aws_kinesis_stream.this.arn]

  attach_sfn_policy = true
  sfn_target_arns   = [module.step_function.state_machine_arn]

  attach_sqs_policy = true
  sqs_target_arns = [
    aws_sqs_queue.queue.arn,
    aws_sqs_queue.fifo.arn,
    aws_sqs_queue.dlq.arn
  ]

  attach_cloudwatch_policy = true
  cloudwatch_target_arns   = [aws_cloudwatch_log_group.this.arn]

  append_rule_postfix = false

  attach_ecs_policy = true
  ecs_target_arns   = [aws_ecs_task_definition.hello_world.arn]

  rules = {
    orders = {
      description   = "Capture all order data"
      event_pattern = jsonencode({ "source" : ["myapp.orders"] })
      state         = "DISABLED" # conflicts with enabled which is deprecated
    }
    emails = {
      description   = "Capture all emails data"
      event_pattern = jsonencode({ "source" : ["myapp.emails"] })
      state         = "ENABLED" # conflicts with enabled which is deprecated
    }
    crons = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(5 minutes)"
    }
    ecs = {
      description = "Capture ECS events"
      event_pattern = jsonencode({
        "source" : ["aws.ecs"]
      })
      # https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-service-event.html#eb-service-event-cloudtrail
      state = "ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS"
    }
  }

  targets = {
    orders = [
      {
        name              = "send-orders-to-sqs"
        arn               = aws_sqs_queue.queue.arn
        input_transformer = local.order_input_transformer
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
      },
      {
        name = "log-orders-to-cloudwatch"
        arn  = aws_cloudwatch_log_group.this.arn
      }
    ]

    emails = [
      {
        name            = "process-email-with-sfn"
        arn             = module.step_function.state_machine_arn
        attach_role_arn = true
      },
      {
        name              = "send-orders-to-kinesis"
        arn               = aws_kinesis_stream.this.arn
        dead_letter_arn   = aws_sqs_queue.dlq.arn
        input_transformer = local.order_input_transformer
        attach_role_arn   = true
      },
      {
        name            = "process-email-with-ecs-task",
        arn             = module.ecs.ecs_cluster_arn,
        attach_role_arn = true
        ecs_target = {
          task_count          = 1
          task_definition_arn = aws_ecs_task_definition.hello_world.arn
        }
      }
    ]

    crons = [
      {
        name  = "something-for-cron"
        arn   = module.lambda.lambda_function_arn
        input = jsonencode({ "job" : "crons" })
      }
    ]

    ecs = [
      {
        name = "something-for-ecs"
        arn  = module.sns.topic_arn
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

  #  # Error can be that maximum 10 policies can be attached to IAM role
  #  attach_policy = true
  #  policy        = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

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
      condition = {
        stringequals_condition = {
          test     = "StringEquals"
          variable = "aws:PrincipalOrgID"
          values   = ["123456789012"]
        }
      }
    }
  }

  ###########################
  # END: Additional policies
  ###########################
}

module "disabled" {
  source = "../../"

  create = false
}

locals {
  order_input_transformer = {
    input_paths = {
      order_id = "$.detail.order_id"
    }
    input_template = <<-EOF
    {
      "id": <order_id>
    }
    EOF
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_kinesis_stream" "this" {
  name        = random_pet.this.id
  shard_count = 1
}

resource "aws_sqs_queue" "queue" {
  name = "${random_pet.this.id}-queue"
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

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/events/${random_pet.this.id}"

  tags = {
    Name = "${random_pet.this.id}-log-group"
  }
}

################
# Step Function
################

module "step_function" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "~> 2.0"

  name = random_pet.this.id

  definition = jsonencode(yamldecode(templatefile("sfn.asl.yaml", {})))

  trusted_entities = ["events.amazonaws.com"]

  service_integrations = {
    stepfunction = {
      stepfunction = ["*"]
    }
  }
}

######
# ECS
######

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 3.0"

  name = random_pet.this.id

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_ecs_service" "hello_world" {
  name            = "hello_world-${random_pet.this.id}"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.hello_world.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}

resource "aws_ecs_task_definition" "hello_world" {
  family = "hello_world-${random_pet.this.id}"

  container_definitions = <<EOF
[
  {
    "name": "hello_world-${random_pet.this.id}",
    "image": "hello-world",
    "cpu": 0,
    "memory": 128
  }
]
EOF
}

#############################################
# Using packaged function from Lambda module
#############################################

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0"

  function_name = "${random_pet.this.id}-lambda"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package         = false
  local_existing_package = local.downloaded

  create_current_version_allowed_triggers = false
  allowed_triggers = {
    ScanAmiRule = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns["crons"]
    }
  }
}

locals {
  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python3.8-zip/existing_package.zip"
  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
}

resource "null_resource" "download_package" {
  triggers = {
    downloaded = local.downloaded
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.downloaded} ${local.package_url}"
  }
}

#######
# SNS
#######

module "sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 6.0"

  name = "${random_pet.this.id}-notifications"
  topic_policy_statements = {
    events = {
      actions = ["sns:publish"]
      principals = [{
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }]
    }
  }
  tags = {
    name = "${random_pet.this.id}-notifications"
  }
}

##############
# CloudTrail
##############

# required for event rule state of ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS
resource "aws_cloudtrail" "trail" {
  name                          = "${random_pet.this.id}-trail"
  s3_bucket_name                = module.bucket.s3_bucket_id
  include_global_service_events = false

  event_selector {
    exclude_management_event_sources = [
      "kms.amazonaws.com",
      "rdsdata.amazonaws.com"
    ]
    read_write_type = "ReadOnly"
  }
}

#######
# s3
#######

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket        = "${random_pet.this.id}-bucket"
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  force_destroy = true
}

# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:GetBucketAcl"]
    resources = [
      "arn:aws:s3:::${random_pet.this.id}-bucket"
    ]
    condition {
      test     = "StringEquals"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${random_pet.this.id}-trail"]
      variable = "aws:SourceArn"
    }
  }

  statement {
    sid = "AWSCloudTrailWrite"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${random_pet.this.id}-bucket/*"
    ]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    condition {
      test     = "StringEquals"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${random_pet.this.id}-trail"]
      variable = "aws:SourceArn"
    }
  }

}

#######
## Lambda
#######
#module "lambda" {
#  source  = "terraform-aws-modules/lambda/aws"
#  version = "~> 2.0"
#
#  function_name = "dev-cron-job"
#  description   = "Lambda Serverless Job"
#  handler       = "index.handler"
#  runtime       = "nodejs14.x"
#  timeout       = 900
#
#  source_path = "../with-lambda-shceduling/lambda"
#}
#
#resource "aws_lambda_permission" "crons_invoke" {
#  statement_id  = "AllowExecutionFromCloudWatch"
#  action        = "lambda:InvokeFunction"
#  function_name = module.lambda.lambda_function_name
#  principal     = "events.amazonaws.com"
#  source_arn    = module.eventbridge.eventbridge_rule_arns.orders
#}
