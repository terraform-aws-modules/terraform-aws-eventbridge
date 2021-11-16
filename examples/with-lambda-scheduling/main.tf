
provider "aws" {
}

module "lambda" {
  source = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "dev-cron-job"
  description = "Lambda Serverless Job"
  handler = "index.handler"
  runtime = "nodejs14.x"
  timeout = 900

  source_path = "./lambda"
}

module "eventbridge" {
  source = "../../"
  create_bus = false
  rules = {
    crons = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(5 minutes)"
    }
  }
  targets = {
    crons = [
      {
        name            = module.lambda.lambda_function_name
        arn             = module.lambda.lambda_function_arn
        input           = jsonencode({"job":"cron-by-rate"})
      }
    ]
  }
}

resource "aws_lambda_permission" "crons_invoke" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal = "events.amazonaws.com"
  source_arn = module.eventbridge.eventbridge_rule_arns.crons
}