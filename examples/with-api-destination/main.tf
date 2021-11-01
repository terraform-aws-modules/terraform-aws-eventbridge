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

  create_bus              = true
  create_connections      = true
  create_api_destinations = true

  bus_name = "${random_pet.this.id}-bus"

  connections = {
    "requestbin" = {
      authorization_type = "BASIC"
      auth_parameters = {
        basic = {
          username = random_pet.this.id
          password = random_pet.this.id
        }
      }
    }
    "github" = {
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
    "requestbin" = {
      description                      = "my requestbin endpoint"
      invocation_endpoint              = "https://pipedream.com/@svenlito/test-rb-1-p_rvCQGl1"
      http_method                      = "POST"
      invocation_rate_limit_per_second = 20
    }
    "github" = {
      description                      = "my github endpoint"
      invocation_endpoint              = "https://pipedream.com/@svenlito/test-rb-2-p_D1Cjq6x"
      http_method                      = "POST"
      invocation_rate_limit_per_second = 20
    }
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_cloudwatch_event_bus" "existing_bus" {
  name = "${random_pet.this.id}-existing-bus"
}
