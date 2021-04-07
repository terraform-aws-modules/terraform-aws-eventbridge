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

  create_permissions = true

  permissions = {
    "099720109477 DevAccess" = {}

    "099720109466 ProdAccess" = {
      action = "events:PutEvents"
    }

    "* PublicAccessToExternalBus" = {
      event_bus_name = aws_cloudwatch_event_bus.external.name
    }
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

resource "aws_cloudwatch_event_bus" "external" {
  name = "${random_pet.this.id}-external"
}
