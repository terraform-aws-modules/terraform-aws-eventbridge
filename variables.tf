variable "bus_name" {
  type    = string
  default = ""
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "trusted_entities" {
  description = "Lambda Function additional trusted entities for assuming roles (trust relationship)"
  type        = list(string)
  default     = []
}

variable "create" {
  description = ""
  type        = bool
  default     = true
}

variable "create_bus" {
  description = ""
  type        = bool
  default     = true
}

variable "create_targets" {
  description = ""
  type        = bool
  default     = true
}

variable "create_permissions" {
  description = ""
  type        = bool
  default     = true
}

variable "create_archive" {
  description = ""
  type        = bool
  default     = false
}

######
# IAM
######

variable "role_name" {
  description = "Name of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_force_detach_policies" {
  description = "Specifies to force detaching any policies the IAM role has before destroying it."
  type        = bool
  default     = true
}

variable "role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM role used by Lambda Function"
  type        = string
  default     = null
}

variable "role_tags" {
  description = "A map of tags to assign to IAM role"
  type        = map(string)
  default     = {}
}

###########
# Policies
###########

variable "attach_kinesis_policy" {
  description = "Controls whether the Kinesis policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "attach_kinesis_firehose_policy" {
  description = "Controls whether the Kinesis Firehose policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "attach_sqs_policy" {
  description = "Controls whether the SQS policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "attach_ecs_policy" {
  description = "Controls whether the ECS policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "attach_sfn_policy" {
  description = "Controls whether the StepFunction policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "kinesis_target_arns" {
  type    = list(string)
  default = []
}

variable "kinesis_firehose_target_arns" {
  type    = list(string)
  default = []
}

variable "sqs_target_arns" {
  type    = list(string)
  default = []
}

variable "ecs_target_arns" {
  type    = list(string)
  default = []
}

variable "sfn_target_arns" {
  type    = list(string)
  default = []
}

variable "archive_config" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "permissions" {
  description = "A list of objects with the permission definitions."
  type        = list(any)
  default     = []
}

variable "rules" {
  description = "A map of objects with the rules definitions."
  type        = map(any)
  default     = {}
}

variable "targets" {
  description = "A Map of objects with the target definitions."
  type        = any
  default     = {}
}
