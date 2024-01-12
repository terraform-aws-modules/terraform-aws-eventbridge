provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

module "eventbridge" {
  source = "../../"

  create_bus      = true
  create_archives = true

  bus_name = "${random_pet.this.id}-bus"

  archives = {
    "launch-archive" = {
      description    = "${random_pet.this.id}-launch-archive",
      retention_days = 1
      event_pattern = jsonencode(
        {
          "source" : ["aws.autoscaling"],
          "detail-type" : ["EC2 Instance Launch Successful"]
        }
      )
    }

    "termination-archive" = {
      name           = "${random_pet.this.id}-termination-archive",
      description    = "${random_pet.this.id}-termination-archive",
      retention_days = 1
      event_pattern = jsonencode(
        {
          "source" : ["aws.ec2"],
          "detail-type" : ["EC2 Instance State-change Notification"],
          "detail" : {
            "state" : ["terminated"]
          }
        }
      )
    }
  }

}

module "eventbridge_archive_only" {
  source = "../../"

  create_bus      = false
  create_archives = true

  archives = {
    "launch-archive-existing-bus" = {
      event_source_arn = aws_cloudwatch_event_bus.existing_bus.arn
      description      = "${random_pet.this.id}-launch-archive",
      retention_days   = 1
      event_pattern = jsonencode(
        {
          "source" : ["aws.autoscaling"],
          "detail-type" : ["EC2 Instance Launch Successful"]
        }
      )
    }
  }

  depends_on = [aws_cloudwatch_event_bus.existing_bus]
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
