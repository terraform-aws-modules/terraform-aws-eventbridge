variable "ecs_cluster" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_security_groups" {
  type = list(string)
}
