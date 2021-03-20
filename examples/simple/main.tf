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

  tags = {
    Name = "${random_pet.this.id}-bus"
  }
}

