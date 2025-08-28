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

variable "create_pipe_role_only" {
  description = "Controls whether an IAM role should be created for the pipes only"
  type        = bool
  default     = false
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

variable "append_schedule_group_postfix" {
  description = "Controls whether to append '-group' to the name of the schedule group"
  type        = bool
  default     = true
}

variable "append_schedule_postfix" {
  description = "Controls whether to append '-schedule' to the name of the schedule"
  type        = bool
  default     = true
}

variable "append_pipe_postfix" {
  description = "Controls whether to append '-pipe' to the name of the pipe"
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

variable "create_schedule_groups" {
  description = "Controls whether EventBridge Schedule Group resources should be created"
  type        = bool
  default     = true
}

variable "create_schedules" {
  description = "Controls whether EventBridge Schedule resources should be created"
  type        = bool
  default     = true
}

variable "create_pipes" {
  description = "Controls whether EventBridge Pipes resources should be created"
  type        = bool
  default     = true
}

#######################

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the region set in the provider configuration"
  type        = string
  default     = null
}

variable "bus_name" {
  description = "A unique name for your EventBridge Bus"
  type        = string
  default     = "default"
}

variable "bus_description" {
  description = "Event bus description"
  type        = string
  default     = null
}

variable "bus_log_config" {
  description = "The configuration block for the EventBridge bus logging"
  type = object({
    include_detail = optional(string)
    level          = optional(string)

    cloudwatch = optional(object({
      enabled       = optional(bool, false)
      log_group_arn = optional(string)
    }))

    s3 = optional(object({
      enabled    = optional(bool, false)
      bucket_arn = optional(string)
    }))

    firehose = optional(object({
      enabled             = optional(bool, false)
      delivery_stream_arn = optional(string)
    }))
  })
  default = null
}

variable "event_source_name" {
  description = "The partner event source that the new event bus will be matched with. Must match name."
  type        = string
  default     = null
}

variable "kms_key_identifier" {
  description = "The identifier of the AWS KMS customer managed key for EventBridge to use, if you choose to use a customer managed key to encrypt events on this event bus. The identifier can be the key Amazon Resource Name (ARN), KeyId, key alias, or key alias ARN."
  type        = string
  default     = null
}

variable "dead_letter_config" {
  description = "Configuration details of the Amazon SQS queue for EventBridge to use as a dead-letter queue (DLQ)"
  type        = any
  default     = {}
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

variable "schedule_groups" {
  description = "A map of objects with EventBridge Schedule Group definitions."
  type        = any
  default     = {}
}

variable "schedules" {
  description = "A map of objects with EventBridge Schedule definitions."
  type        = map(any)
  default     = {}
}

variable "pipes" {
  description = "A map of objects with EventBridge Pipe definitions."
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "schedule_group_timeouts" {
  description = "A map of objects with EventBridge Schedule Group create and delete timeouts."
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

variable "policy_path" {
  description = "Path of IAM policy to use for EventBridge"
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

variable "ecs_pass_role_resources" {
  description = "List of approved roles to be passed"
  type        = list(string)
  default     = []
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

variable "attach_sns_policy" {
  description = "Controls whether the SNS policy should be added to IAM role for EventBridge Target"
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

variable "sns_target_arns" {
  description = "The Amazon Resource Name (ARN) of the AWS SNS's you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "sns_kms_arns" {
  description = "The Amazon Resource Name (ARN) of the AWS KMS's configured for AWS SNS you want Decrypt/GenerateDataKey for"
  type        = list(string)
  default     = ["*"]
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
  description = "Additional trusted entities for assuming roles (trust relationship)"
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
