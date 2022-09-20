provider "aws" {
  region = "ap-southeast-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

#############################################################
# Data sources to get VPC and default security group details
#############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

####################
# Actual Eventbridge
####################
module "eventbridge" {
  source = "../../"

  # Schedules can only be created on default bus
  create_bus = false

  create_role       = true
  role_name         = "ecs-eventbridge-${random_pet.this.id}"
  attach_ecs_policy = true
  ecs_target_arns   = [aws_ecs_task_definition.hello_world.arn]

  # Fire every five minutes
  rules = {
    orders = {
      description         = "Cron for Orders"
      enabled             = false
      schedule_expression = "rate(5 minutes)"
    }
  }

  # Send to a fargate ECS cluster
  targets = {
    orders = [
      {
        name            = "orders"
        arn             = module.ecs.ecs_cluster_arn
        attach_role_arn = true

        ecs_target = {
          launch_type         = "FARGATE"
          task_count          = 1
          task_definition_arn = aws_ecs_task_definition.hello_world.arn

          network_configuration = {
            assign_public_ip = true
            subnets          = data.aws_subnet_ids.default.ids
            security_groups  = [data.aws_security_group.default.arn]
          }
        }
      }
    ]
  }
}

######
# ECS
######

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 3.0"

  name = random_pet.this.id

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_ecs_service" "hello_world" {
  name            = "hello_world-${random_pet.this.id}"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.hello_world.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}

resource "aws_ecs_task_definition" "hello_world" {
  family = "hello_world-${random_pet.this.id}"

  container_definitions = jsonencode([
    {
      name   = "hello_world-${random_pet.this.id}",
      image  = "hello-world",
      cpu    = 0,
      memory = 128
    }
  ])
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}
