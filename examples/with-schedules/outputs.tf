# EventBridge Schedule Group
output "eventbridge_schedule_group_ids" {
  description = "The EventBridge Schedule Group IDs"
  value       = module.eventbridge.eventbridge_schedule_arns
}

output "eventbridge_schedule_group_arns" {
  description = "The EventBridge Schedule Group ARNs"
  value       = module.eventbridge.eventbridge_schedule_group_arns
}

output "eventbridge_schedule_group_states" {
  description = "The EventBridge Schedule Group states"
  value       = module.eventbridge.eventbridge_schedule_group_states
}

# EventBridge Schedule
output "eventbridge_schedule_ids" {
  description = "The EventBridge Schedule IDs created"
  value       = module.eventbridge.eventbridge_schedule_ids
}

output "eventbridge_schedule_arns" {
  description = "The EventBridge Schedule ARNs created"
  value       = module.eventbridge.eventbridge_schedule_arns
}

# Lambda Function
output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = module.lambda.lambda_function_name
}
