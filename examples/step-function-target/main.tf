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

  attach_sfn_policy = true
  sfn_target_arns   = [module.step_function.this_state_machine_arn]

  rules = {
    orders = {
      description   = "Capture order data"
      event_pattern = jsonencode({ "source" : ["your.app.orders"] })
    }
  }

  targets = {
    orders = [
      {
        name            = "process-order-with-sfn"
        arn             = module.step_function.this_state_machine_arn
        attach_role_arn = true
      }
    ]
  }

  tags = {
    Name = "${random_pet.this.id}-bus"
  }
}

module "step_function" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "1.2.0"

  name = random_pet.this.id

  definition = jsonencode(yamldecode(templatefile("sfn.asl.yaml", {})))

  trusted_entities = ["events.amazonaws.com"]

  service_integrations = {
    stepfunction = {
      stepfunction = ["*"]
    }
  }

  tags = {
    Name = "${random_pet.this.id}-step-function"
  }
}
