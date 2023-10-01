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

# Resources
output "eventbridge_pipes" {
  description = "The EventBridge Pipes created and their attributes"
  value       = module.eventbridge.eventbridge_pipes
}

output "eventbridge_pipes_iam_roles" {
  description = "The EventBridge Pipes IAM roles created and their attributes"
  value       = module.eventbridge.eventbridge_pipes_iam_roles
}
