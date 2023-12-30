provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
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

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
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
  ecs_target_arns   = [module.ecs_cluster.services["hello-world"].task_definition_arn]

  # Fire every five minutes
  rules = {
    orders = {
      description         = "Cron for Orders"
      state               = "DISABLED" # conflicts with enabled which is deprecated
      schedule_expression = "rate(5 minutes)"
    }
  }

  # Send to a fargate ECS cluster
  targets = {
    orders = [
      {
        name            = "orders"
        arn             = module.ecs_cluster.cluster_arn
        attach_role_arn = true

        ecs_target = {
          # If a capacity_provider_strategy specified, the launch_type parameter must be omitted.
          # launch_type         = "FARGATE"
          task_count              = 1
          task_definition_arn     = module.ecs_cluster.services["hello-world"].task_definition_arn
          enable_ecs_managed_tags = true
          tags = {
            production = true
          }

          network_configuration = {
            assign_public_ip = true
            subnets          = data.aws_subnets.default.ids
            security_groups  = [data.aws_security_group.default.id]
          }

          # If a capacity_provider_strategy is specified, the launch_type parameter must be omitted.
          # If no capacity_provider_strategy or launch_type is specified, the default capacity provider strategy for the cluster is used.
          capacity_provider_strategy = [
            {
              capacity_provider = "FARGATE"
              base              = 1
              weight            = 100
            },
            {
              capacity_provider = "FARGATE_SPOT"
              weight            = 100
            }
          ]
        }
      }
    ]
  }
}

######
# ECS
######

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.0"

  cluster_name = random_pet.this.id

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    hello-world = {
      subnet_ids                         = data.aws_subnets.default.ids
      desired_count                      = 1
      deployment_maximum_percent         = 100
      deployment_minimum_healthy_percent = 0

      container_definitions = {
        hello-world = {
          image  = "hello-world",
          cpu    = 0,
          memory = 128
        }
      }
    }
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}
