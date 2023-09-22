provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

module "eventbridge" {
  source = "../../"

  create_bus = true
  bus_name   = "example"

  create_api_destinations = true
  create_connections      = true

  connections = {
    smee = {
      authorization_type = "API_KEY"
      auth_parameters = {
        api_key = {
          key   = "x-signature-id"
          value = random_pet.this.id
        }
      }
    }
  }

  api_destinations = {
    smee = { # This key should match the key inside "connections"
      description                      = "my smee endpoint"
      invocation_endpoint              = "https://smee.io/6hx6fuQaVUKLfALn"
      http_method                      = "POST"
      invocation_rate_limit_per_second = 200
    }
  }

  pipes = {
    complete = {
      source = aws_sqs_queue.source.arn
      target = aws_sqs_queue.target.arn

      enrichment = "smee" # This key should match the key inside "api_destinations"
      enrichment_parameters = {
        input_template = jsonencode({ input : "yes" })

        http_parameters = {
          path_parameter_values = ["example-path-param"]

          header_parameters = {
            "example-header"        = "example-value"
            "second-example-header" = "second-example-value"
          }

          query_string_parameters = {
            "example-query-string"        = "example-value"
            "second-example-query-string" = "second-example-value"
          }
        }
      }

      tags = {
        Pipe = "complete"
      }
    }

    minimal_with_role = {
      role_name = "something" # This IAM role will be created

      source = aws_sqs_queue.source.arn
      target = aws_sqs_queue.target.arn

      #      enrichment = aws_cloudwatch_event_api_destination.external.arn

      tags = {
        Pipe = "minimal-with-role"
      }
    }

    external_role = {
      # This IAM Role will be used by the Pipe
      create_role = false
      role_arn    = aws_iam_role.eventbridge_pipe.arn

      #"arn:aws:iam::835367859851:role/service-role/Amazon_EventBridge_Pipe_test_85cdfd6c"

      source = aws_sqs_queue.source.arn
      target = aws_sqs_queue.target.arn

      tags = {
        Pipe = "external-role"
      }
    }

    # No filtering and no enrichment
    minimal = {
      source = aws_sqs_queue.source.arn
      target = aws_sqs_queue.target.arn

      tags = {
        Pipe = "minimal"
      }
    }
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}


###############################
# API Destination / Connection
###############################

resource "aws_cloudwatch_event_api_destination" "external" {
  name                = "${random_pet.this.id}-external"
  invocation_endpoint = "https://smee.io/6hx6fuQaVUKLfALn"
  http_method         = "POST"
  connection_arn      = aws_cloudwatch_event_connection.external.arn
}

resource "aws_cloudwatch_event_connection" "external" {
  name               = "${random_pet.this.id}-external"
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key   = "x-signature"
      value = "1234"
    }
  }
}

#################################
# IAM role for EventBridge Pipes
#################################

data "aws_iam_policy_document" "assume_role_pipe" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["pipes.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eventbridge_pipe" {
  name               = "${random_pet.this.id}-pipe"
  assume_role_policy = data.aws_iam_policy_document.assume_role_pipe.json
}

resource "aws_iam_role_policy_attachment" "pipe" {
  role       = aws_iam_role.eventbridge_pipe.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

#############
# SQS Queues
#############

resource "aws_sqs_queue" "source" {
  name = "${random_pet.this.id}-source"
}

resource "aws_sqs_queue" "target" {
  name = "${random_pet.this.id}-target"
}

#############################################
# Using packaged function from Lambda module
#############################################
#
#module "lambda" {
#  source  = "terraform-aws-modules/lambda/aws"
#  version = "~> 5.0"
#
#  function_name = "${random_pet.this.id}-lambda"
#  handler       = "index.lambda_handler"
#  runtime       = "python3.8"
#
#  create_package         = false
#  local_existing_package = local.downloaded
#
#  trusted_entities = ["scheduler.amazonaws.com"]
#
#  create_current_version_allowed_triggers = false
#  allowed_triggers = {
#    ScanAmiRule = {
#      principal  = "scheduler.amazonaws.com"
#      source_arn = module.eventbridge.eventbridge_schedule_arns["lambda-cron"]
#    }
#  }
#}
#
#locals {
#  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python3.8-zip/existing_package.zip"
#  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
#}
#
#resource "null_resource" "download_package" {
#  triggers = {
#    downloaded = local.downloaded
#  }
#
#  provisioner "local-exec" {
#    command = "curl -L -o ${local.downloaded} ${local.package_url}"
#  }
#}
