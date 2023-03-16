output "eventbridge_schedule_arns" {
  description = "The EventBridge Schedule ARNs"
  value       = module.eventbridge.eventbridge_schedule_arns
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = module.lambda.lambda_function_name
}
