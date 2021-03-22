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

  create_archives = true

  archive_config = [
    {
      name           = "${random_pet.this.id}-launch-archive",
      description    = "${random_pet.this.id}-launch-archive",
      retention_days = 1
      event_pattern  = <<PATTERN
      {
        "source": ["aws.autoscaling"],
        "detail-type": ["EC2 Instance Launch Successful"]
      }
      PATTERN
    },
    {
      name           = "${random_pet.this.id}-termination-archive",
      description    = "${random_pet.this.id}-termination-archive",
      retention_days = 1
      event_pattern  = <<PATTERN
      {
        "source": ["aws.ec2"],
        "detail-type": ["EC2 Instance State-change Notification"],
        "detail": {
          "state": ["terminated"]
        }
      }
      PATTERN
    }
  ]

  bus_name = "${random_pet.this.id}-bus"

  tags = {
    Name = "${random_pet.this.id}-bus"
  }
}

module "eventbridge_archive_only" {
  source = "../../"

  create_bus      = false
  create_rules    = false
  create_targets  = false
  create_archives = true

  archive_config = [
    {
      event_source_arn = aws_cloudwatch_event_bus.pre_existing_bus.arn
      name             = "${random_pet.this.id}-launch-archive",
      description      = "${random_pet.this.id}-launch-archive",
      retention_days   = 1
      event_pattern    = <<PATTERN
      {
        "source": ["aws.autoscaling"],
        "detail-type": ["EC2 Instance Launch Successful"]
      }
      PATTERN
    }
  ]

  tags = {
    Name = "${random_pet.this.id}-bus"
  }
}

##################
# Extra resources
##################

resource "aws_cloudwatch_event_bus" "pre_existing_bus" {
  name = "${random_pet.this.id}-bus"
}

