variable "bus_name" {
  description = "A unique name for your EventBridge Bus"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "create_role" {
  description = "Controls whether IAM role for Lambda Function should be created"
  type        = bool
  default     = true
}

variable "create_bus" {
  description = "Controls whether EventBridge Bus resource should be created"
  type        = bool
  default     = true
}

variable "create_rules" {
  description = "Controls whether EventBridge Rule resources should be created"
  type        = bool
  default     = true
}

variable "create_targets" {
  description = "Controls whether EventBridge Target resources should be created"
  type        = bool
  default     = true
}

variable "create_permissions" {
  description = "Controls whether EventBridge Permission resources should be created"
  type        = bool
  default     = true
}

variable "create_archives" {
  description = "Controls whether EventBridge Archive resources should be created"
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

variable "attach_tracing_policy" {
  description = "Controls whether X-Ray tracing policy should be added to IAM role for EventBridge"
  type        = bool
  default     = false
}

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

variable "attach_lambda_policy" {
  description = "Controls whether the Lambda Function policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "attach_sfn_policy" {
  description = "Controls whether the StepFunction policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "attach_cloudwatch_policy" {
  description = "Controls whether the Cloudwatch policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "kinesis_target_arns" {
  description = "The Amazon Resource Name (ARN) of the Kinesis Streams you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "kinesis_firehose_target_arns" {
  description = "The Amazon Resource Name (ARN) of the Kinesis Firehose Delivery Streams you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "sqs_target_arns" {
  description = "The Amazon Resource Name (ARN) of the AWS SQS Queues you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "ecs_target_arns" {
  description = "The Amazon Resource Name (ARN) of the AWS ECS Tasks you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "lambda_target_arns" {
  description = "The Amazon Resource Name (ARN) of the Lambda Functions you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "sfn_target_arns" {
  description = "The Amazon Resource Name (ARN) of the StepFunctions you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "cloudwatch_target_arns" {
  description = "The Amazon Resource Name (ARN) of the Cloudwatch Log Streams you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "archive_configs" {
  description = "A list of objects with the EventBridge Archive definitions."
  type        = list(any)
  default     = []
}

variable "permissions" {
  description = "A list of objects with EventBridge Permission definitions."
  type        = list(any)
  default     = []
}

variable "rules" {
  description = "A map of objects with EventBridge Rule definitions."
  type        = map(any)
  default     = {}
}

variable "targets" {
  description = "A Map of objects with EventBridge Target definitions."
  type        = any
  default     = {}
}
