####################
# Actual Eventbridge
####################
module "eventbridge" {
  source = "../../"

  # Schedules can only be created on default bus
  create_bus = false

  # Fire every five minutes
  rules = {
    orders = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(5 minutes)"
    }
  }

  # Send to a lambda with an custom input.
  targets = {
    orders = [
      {
        name            = "dev-cron-job"
        arn             = module.lambda.lambda_arn
        input           = jsonencode({"job":"orders"})
      }
    ]
  }
}

######
# Lambda
######

module "lambda" {
  source = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "dev-cron-job"
  description = "Lambda Serverless Job"
  handler = "index.handler"
  runtime = "nodejs14.x"
  timeout = 900

  allowed_triggers = {
    DevCronJob = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns.orders
    }
  }

  create_current_version_allowed_triggers = false
}
