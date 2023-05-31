provider "aws" {
  region = "ap-southeast-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

module "eventbridge" {
  source = "../../"

  create_bus = false

  trusted_entities = ["scheduler.amazonaws.com"]

  attach_lambda_policy = true
  lambda_target_arns   = [module.lambda.lambda_function_arn]

  schedules = {
    lambda-cron = {
      description         = "Trigger for a Lambda"
      schedule_expression = "cron(0 1 * * ? *)"
      timezone            = "Europe/London"
      arn                 = module.lambda.lambda_function_arn
      input               = jsonencode({ "job" : "cron-by-rate" })
    }
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

#############################################
# Using packaged function from Lambda module
#############################################

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "${random_pet.this.id}-lambda"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package         = false
  local_existing_package = local.downloaded

  trusted_entities = ["scheduler.amazonaws.com"]

  create_current_version_allowed_triggers = false
  allowed_triggers = {
    ScanAmiRule = {
      principal  = "scheduler.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_schedule_arns["lambda-cron"]
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
