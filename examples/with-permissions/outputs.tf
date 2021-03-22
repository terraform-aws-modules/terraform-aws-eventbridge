output "eventbridge_bus_arn" {
  description = "The EventBridge Bus ARN"
  value       = module.eventbridge.this_eventbridge_bus_arn
}

output "this_eventbridge_permission_ids" {
  description = "The EventBridge Permissions"
  value       = module.eventbridge.this_eventbridge_permission_ids
}
