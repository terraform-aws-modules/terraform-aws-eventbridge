variable "ecs_cluster" {
  description = "An ECS cluster ARN to launch tasks in."
  type        = string
}

variable "public_subnets" {
  description = "public subnets the task should run in."
  type        = list(string)
}

variable "vpc_security_groups" {
  description = "vpc security groups the task should run in."
  type        = list(string)
}
