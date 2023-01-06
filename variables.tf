variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "create_role" {
  description = "Controls whether IAM roles should be created"
  type        = bool
  default     = true
}

variable "append_rule_postfix" {
  description = "Controls whether to append '-rule' to the name of the rule"
  type        = bool
  default     = true
}

variable "append_connection_postfix" {
  description = "Controls whether to append '-connection' to the name of the connection"
  type        = bool
  default     = true
}

variable "append_destination_postfix" {
  description = "Controls whether to append '-destination' to the name of the destination"
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

variable "create_connections" {
  description = "Controls whether EventBridge Connection resources should be created"
  type        = bool
  default     = false
}

variable "create_api_destinations" {
  description = "Controls whether EventBridge Destination resources should be created"
  type        = bool
  default     = false
}

variable "create_schemas_discoverer" {
  description = "Controls whether default schemas discoverer should be created"
  type        = bool
  default     = false
}

#######################

variable "bus_name" {
  description = "A unique name for your EventBridge Bus"
  type        = string
  default     = "default"
}

variable "schemas_discoverer_description" {
  description = "Default schemas discoverer description"
  type        = string
  default     = "Auto schemas discoverer event"
}

variable "rules" {
  description = "A map of objects with EventBridge Rule definitions."
  type        = map(any)
  default     = {}
}

variable "targets" {
  description = "A map of objects with EventBridge Target definitions."
  type        = any
  default     = {}
}

variable "archives" {
  description = "A map of objects with the EventBridge Archive definitions."
  type        = map(any)
  default     = {}
}

variable "permissions" {
  description = "A map of objects with EventBridge Permission definitions."
  type        = map(any)
  default     = {}
}

variable "connections" {
  description = "A map of objects with EventBridge Connection definitions."
  type        = any
  default     = {}
}

variable "api_destinations" {
  description = "A map of objects with EventBridge Destination definitions."
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

######
# IAM
######

variable "role_name" {
  description = "Name of IAM role to use for EventBridge"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of IAM role to use for EventBridge"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for EventBridge"
  type        = string
  default     = null
}

variable "role_force_detach_policies" {
  description = "Specifies to force detaching any policies the IAM role has before destroying it."
  type        = bool
  default     = true
}

variable "role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM role used by EventBridge"
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

variable "attach_api_destination_policy" {
  description = "Controls whether the API Destination policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "attach_tracing_policy" {
  description = "Controls whether X-Ray tracing policy should be added to IAM role for EventBridge"
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

##########################
# Various custom policies
##########################

variable "attach_policy_json" {
  description = "Controls whether policy_json should be added to IAM role"
  type        = bool
  default     = false
}

variable "attach_policy_jsons" {
  description = "Controls whether policy_jsons should be added to IAM role"
  type        = bool
  default     = false
}

variable "attach_policy" {
  description = "Controls whether policy should be added to IAM role"
  type        = bool
  default     = false
}

variable "attach_policies" {
  description = "Controls whether list of policies should be added to IAM role"
  type        = bool
  default     = false
}

variable "number_of_policy_jsons" {
  description = "Number of policies JSON to attach to IAM role"
  type        = number
  default     = 0
}

variable "number_of_policies" {
  description = "Number of policies to attach to IAM role"
  type        = number
  default     = 0
}

variable "attach_policy_statements" {
  description = "Controls whether policy_statements should be added to IAM role"
  type        = bool
  default     = false
}

variable "trusted_entities" {
  description = "Step Function additional trusted entities for assuming roles (trust relationship)"
  type        = list(string)
  default     = []
}

variable "policy_json" {
  description = "An additional policy document as JSON to attach to IAM role"
  type        = string
  default     = null
}

variable "policy_jsons" {
  description = "List of additional policy documents as JSON to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "policy" {
  description = "An additional policy document ARN to attach to IAM role"
  type        = string
  default     = null
}

variable "policies" {
  description = "List of policy statements ARN to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to IAM role"
  type        = any
  default     = {}
}
