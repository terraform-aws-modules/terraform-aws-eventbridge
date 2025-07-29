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

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_sqs_queue" "source" {
  name = "${random_pet.this.id}-source"
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

  pipes = {
    test_ecs_pipe = {

      source = aws_sqs_queue.source.arn
      target = module.ecs_cluster.cluster_arn

      attach_policies_for_integrations = true

      target_parameters = {
        ecs_task_parameters = {
          assign_public_ip    = "ENABLED"
          task_count          = 1
          launch_type         = "FARGATE"
          task_definition_arn = module.ecs_cluster.services["hello-world"].task_definition_arn
          container_name      = "hello-world"

          security_groups = [data.aws_security_group.default.id]
          subnets         = data.aws_subnets.default.ids

          memory = 512
          cpu    = 256

          enable_ecs_managed_tags = true
        }
      }
    }
  }
}

resource "aws_iam_policy" "eventbridge_pipes_ecs_policy" {
  name        = "test-pipes-ecs-policy"
  description = "Policy for EventBridge Pipes to run ECS tasks"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask",
          "ecs:TagResource"
        ]
        Resource = [module.ecs_cluster.services["hello-world"].task_definition_arn]
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          module.ecs_cluster.services["hello-world"].task_exec_iam_role_arn,
          module.ecs_cluster.services["hello-world"].tasks_iam_role_arn
        ]
        Condition = {
          StringLike = {
            "iam:PassedToService" = "ecs-tasks.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_pipes_ecs_policy" {
  for_each = module.eventbridge.eventbridge_pipe_role_names

  role       = each.value
  policy_arn = aws_iam_policy.eventbridge_pipes_ecs_policy.arn
}

######
# ECS
######

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 6.1"

  cluster_name = random_pet.this.id


  default_capacity_provider_strategy = {
    "FARGATE" = {
      weight = 100
    }
  }

  services = {
    hello-world = {
      create_service                     = false
      subnet_ids                         = data.aws_subnets.default.ids
      desired_count                      = 1
      deployment_maximum_percent         = 100
      deployment_minimum_healthy_percent = 0

      container_definitions = {
        hello-world = {
          image  = "public.ecr.aws/docker/library/hello-world:latest",
          cpu    = 256,
          memory = 512
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

