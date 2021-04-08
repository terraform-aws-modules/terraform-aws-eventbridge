output "eventbridge_bus_arn" {
  description = "The EventBridge Bus ARN"
  value       = module.eventbridge.eventbridge_bus_arn
}

output "eventbridge_permission_ids" {
  description = "The EventBridge Permissions"
  value       = module.eventbridge.eventbridge_permission_ids
}
