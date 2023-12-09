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
    # With enrichment via API Destination
    enrichment = {
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
        Pipe = "enrichment"
      }
    }

    # With enrichment via API Destination created outside of the module
    external_enrichment = {
      source = aws_sqs_queue.source.arn
      target = aws_sqs_queue.target.arn

      enrichment = aws_cloudwatch_event_api_destination.external.arn

      tags = {
        Pipe = "external_enrichment"
      }
    }

    # With SQS source/target parameters and filtering
    sqs_source_sqs_target = {
      source = aws_sqs_queue.source.arn
      target = aws_sqs_queue.target.arn

      source_parameters = {
        # Filter criteria (max 5 filters)
        filter_criteria = {
          filter1 = {
            pattern = jsonencode({ source = ["event-source1"] })
          }
          filter2 = {
            pattern = jsonencode({ source = ["event-source2"] })
          }
        }

        sqs_queue_parameters = {
          batch_size                         = 2
          maximum_batching_window_in_seconds = 61
        }
      }

      # target_parameters = {
      #   # Only supported for target FIFO SQS Queues
      #   sqs_queue_parameters = {
      #     message_deduplication_id = "deduplication-id"
      #     message_group_id         = "group1"
      #   }
      # }

      tags = {
        Pipe = "sqs_source_sqs_target"
      }
    }

    # With DynamoDB Stream source and SQS target
    dynamodb_stream_source_sqs_target = {
      source = aws_dynamodb_table.source.stream_arn
      target = aws_sqs_queue.target.arn

      source_parameters = {
        dynamodb_stream_parameters = {
          batch_size                         = 10
          maximum_batching_window_in_seconds = 50
          maximum_record_age_in_seconds      = 100
          maximum_retry_attempts             = 300
          on_partial_batch_item_failure      = "AUTOMATIC_BISECT"
          parallelization_factor             = 5
          starting_position                  = "LATEST"
          dead_letter_config = {
            arn = aws_sqs_queue.dlq.arn
          }
        }
      }

      target_parameters = {
        input_template = "{\"data\":<$.dynamodb>}"
      }

      tags = {
        Pipe = "dynamodb_stream_source_sqs_target"
      }
    }

    # With Kinesis Stream source and CloudWatch Log
    kinesis_source_cloudwatch_target = {
      source = aws_kinesis_stream.source.arn
      target = aws_cloudwatch_log_group.target.arn

      source_parameters = {
        kinesis_stream_parameters = {
          batch_size                         = 7
          maximum_batching_window_in_seconds = 90
          maximum_record_age_in_seconds      = 100
          maximum_retry_attempts             = 4
          on_partial_batch_item_failure      = "AUTOMATIC_BISECT"
          parallelization_factor             = 5
          starting_position                  = "TRIM_HORIZON"
          starting_position_timestamp        = null
          dead_letter_config = {
            arn = aws_sqs_queue.dlq.arn
          }
        }
      }

      target_parameters = {
        cloudwatch_logs_parameters = {
          log_stream_name = aws_cloudwatch_log_stream.target.arn
        }
      }

      tags = {
        Pipe = "kinesis_source_cloudwatch_target"
      }
    }

    # With SQS Queue source and EventBridge target
    sqs_source_eventbridge_target = {
      source = aws_sqs_queue.source.arn
      target = aws_cloudwatch_event_bus.target.arn

      target_parameters = {
        eventbridge_event_bus_parameters = {
          detail_type = "my-target"
          endpoint_id = "endpoint.com"
          resources   = []
          source      = 20
        }
      }

      tags = {
        Pipe = "sqs_source_eventbridge_target"
      }
    }

    # With SQS Queue source and Lambda target
    sqs_source_lambda_target = {
      source = aws_sqs_queue.source.arn
      target = module.lambda_target.lambda_function_arn

      target_parameters = {
        lambda_function_parameters = {
          invocation_type = "REQUEST_RESPONSE"
        }
      }

      tags = {
        Pipe = "sqs_source_lambda_target"
      }
    }

    # With SQS Queue source and StepFunction target
    sqs_source_step_function_target = {
      source = aws_sqs_queue.source.arn
      target = module.step_function_target.state_machine_arn

      target_parameters = {
        step_function_state_machine_parameters = {
          invocation_type = "FIRE_AND_FORGET"
        }
      }

      tags = {
        Pipe = "sqs_source_step_function_target"
      }
    }

    # With SQS Queue source and HTTP target
    sqs_source_http_target = {
      source = aws_sqs_queue.source.arn
      target = aws_cloudwatch_event_api_destination.external.arn

      target_parameters = {
        http_parameters = {
          header_parameters = {
            "x-my-header" = "my-value"
          }
          path_parameter_values = ["user1"]
          query_string_parameters = {
            "key1" = "value1"
          }
        }
      }

      tags = {
        Pipe = "sqs_source_http_target"
      }
    }

    # Minimal with specific IAM role name to create
    minimal_role_name_prefix = {
      role_name_prefix = "something"

      source = aws_sqs_queue.source.arn
      target = aws_sqs_queue.target.arn

      role_tags = {
        MyRoleTag = "TagValue"
      }

      tags = {
        Pipe = "minimal_role_name_prefix"
      }
    }

    # Minimal with IAM role created outside of the module
    minimal_external_role = {
      create_role = false
      role_arn    = aws_iam_role.eventbridge_pipe.arn

      source = aws_sqs_queue.source.arn
      target = aws_sqs_queue.target.arn

      tags = {
        Pipe = "minimal_external_role"
      }
    }

    # No filtering, source/target parameters, enrichment
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

# PowerUserAccess policy is used here just for testing purposes
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

resource "aws_sqs_queue" "dlq" {
  name = "${random_pet.this.id}-dlq"
}

#############################
# DynamoDB Table with Stream
#############################

resource "aws_dynamodb_table" "source" {
  name = "${random_pet.this.id}-source"

  hash_key       = "id"
  range_key      = "title"
  table_class    = "STANDARD"
  read_capacity  = 1
  write_capacity = 1

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "N"
  }

  attribute {
    name = "title"
    type = "S"
  }
}

#################
# Kinesis Stream
#################

resource "aws_kinesis_stream" "source" {
  name = "${random_pet.this.id}-source"

  shard_count = 1
}

##################################
# CloudWatch Log Group and Stream
##################################

resource "aws_cloudwatch_log_group" "target" {
  name = "${random_pet.this.id}-target"
}

resource "aws_cloudwatch_log_stream" "target" {
  log_group_name = aws_cloudwatch_log_group.target.name
  name           = "${random_pet.this.id}-target"
}

##################
# EventBridge Bus
##################

resource "aws_cloudwatch_event_bus" "target" {
  name = "${random_pet.this.id}-target"
}

#############################################
# Using packaged function from Lambda module
#############################################

module "lambda_target" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0"

  function_name = "${random_pet.this.id}-lambda"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package         = false
  local_existing_package = local.downloaded
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

####################
# AWS Step Function
####################

module "step_function_target" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "~> 2.0"

  name = "${random_pet.this.id}-target"

  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using Pass states",
  "StartAt": "Hello",
  "States": {
    "Hello": {
      "Type": "Pass",
      "Result": "Hello",
      "End": true
    }
  }
}
EOF
}
