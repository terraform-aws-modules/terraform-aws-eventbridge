# EventBridge Pipes
output "eventbridge_pipe_ids" {
  description = "The EventBridge Pipes IDs"
  value       = module.eventbridge.eventbridge_pipe_ids
}

output "eventbridge_pipe_arns" {
  description = "The EventBridge Pipes ARNs"
  value       = module.eventbridge.eventbridge_pipe_arns
}

# IAM Role for EventBridge Pipes
output "eventbridge_pipe_role_arns" {
  description = "The ARNs of the IAM role created for EventBridge Pipes"
  value       = module.eventbridge.eventbridge_pipe_role_arns
}

output "eventbridge_pipe_role_names" {
  description = "The names of the IAM role created for EventBridge Pipes"
  value       = module.eventbridge.eventbridge_pipe_role_names
}
