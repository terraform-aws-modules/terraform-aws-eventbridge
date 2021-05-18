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

  attach_ecs_policy = true
  ecs_target_arns   = [aws_ecs_task_definition.hello_world.arn]

  attach_cloudwatch_policy = true
  cloudwatch_target_arns   = [aws_cloudwatch_log_group.this.arn]

  rules = {
    logs = {
      description = "Capture S3 Events"
      event_pattern = jsonencode({
        "source" : ["aws.s3"],
        "detail-type" : ["AWS API Call via CloudTrail"],
        "detail" : {
          "eventSource" : ["s3.amazonaws.com"],
          "eventName" : ["PutObject"],
          "requestParameters" : {
            "bucketName" : [module.source_bucket.s3_bucket_id]
          }
        }
      })
    }
  }

  targets = {
    logs = [
      {
        name            = "send-putobject-events-to-ecs-task",
        arn             = module.ecs.ecs_cluster_arn,
        attach_role_arn = true
        ecs_target = {
          task_count          = 1
          task_definition_arn = aws_ecs_task_definition.hello_world.arn
        }
      },
      {
        name = "send-putobject-events-to-cloudwatch"
        arn  = aws_cloudwatch_log_group.this.arn
      }
    ]
  }
}

locals {
  name               = random_pet.this.id
  ec2_resources_name = "${random_pet.this.id}-dev"
  environment        = "dev"
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/events/${random_pet.this.id}"

  tags = {
    Name = "${random_pet.this.id}-log-group"
  }
}

#####
# S3
#####

module "cloudtrail_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2.0"

  bucket        = "${random_pet.this.id}-cloudtrail"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket     = module.cloudtrail_bucket.s3_bucket_id
  depends_on = [module.cloudtrail_bucket]
  policy     = data.aws_iam_policy_document.cloudtrail_policy.json
}

data "aws_iam_policy_document" "cloudtrail_policy" {
  statement {
    sid     = "AWSCloudTrailAclCheck20150319"
    effect  = "Allow"
    actions = ["s3:GetBucketAcl"]
    resources = [
      module.cloudtrail_bucket.s3_bucket_arn,
      "${module.cloudtrail_bucket.s3_bucket_arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid     = "AWSCloudTrailWrite20150319"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "${module.cloudtrail_bucket.s3_bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

module "source_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2.0"

  bucket        = "${random_pet.this.id}-source"
  force_destroy = true
}

resource "aws_cloudtrail" "this" {
  name                          = random_pet.this.id
  s3_bucket_name                = module.cloudtrail_bucket.s3_bucket_id
  include_global_service_events = true
  is_multi_region_trail         = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${module.source_bucket.s3_bucket_arn}/"]
    }
  }
}

data "aws_caller_identity" "current" {}

######
# ECS
######

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 3.0"

  name = random_pet.this.id

  capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.prov1.name]

  default_capacity_provider_strategy = [{
    capacity_provider = aws_ecs_capacity_provider.prov1.name # "FARGATE_SPOT"
    weight            = "1"
  }]
}

resource "aws_ecs_capacity_provider" "prov1" {
  name = "prov1"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.autoscaling_group_arn
  }
}

resource "aws_ecs_service" "hello_world" {
  name            = "hello_world-${random_pet.this.id}"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.hello_world.arn
  launch_type     = "EC2"

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}

resource "aws_ecs_task_definition" "hello_world" {
  family = "hello_world-${random_pet.this.id}"

  container_definitions = <<EOF
[
  {
    "name": "hello_world-${random_pet.this.id}",
    "image": "hello-world",
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "eu-west-1",
        "awslogs-group": "hello_world-${random_pet.this.id}",
        "awslogs-stream-prefix": "complete-ecs"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name              = "hello_world-${random_pet.this.id}"
  retention_in_days = 1
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = false # false is just faster

  tags = {
    Environment = local.environment
    Name        = local.name
  }
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  name = local.ec2_resources_name

  # Launch configuration
  lc_name   = local.ec2_resources_name
  use_lc    = true
  create_lc = true

  image_id                 = data.aws_ami.amazon_linux_ecs.id
  instance_type            = "t3a.micro"
  security_groups          = [module.vpc.default_security_group_id]
  iam_instance_profile_arn = module.ec2_profile.iam_instance_profile_arn
  user_data                = data.template_file.user_data.rendered

  # Auto scaling group
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 2
  desired_capacity          = 0 # we don't need them for the example
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = local.environment
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = local.name
      propagate_at_launch = true
    }
  ]
}

module "ec2_profile" {
  source = "./modules/ecs-instance-profile"

  name = random_pet.this.id

  tags = {
    Environment = local.environment
  }
}

#For now we only use the AWS ECS optimized ami <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html>
data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    cluster_name = random_pet.this.id
  }
}
