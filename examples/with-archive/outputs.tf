output "eventbridge_bus_arn" {
  description = "The EventBridge Bus ARN"
  value       = module.eventbridge.this_eventbridge_bus_arn
}

output "eventbridge_archive_arns" {
  description = "The EventBridge Archive ARNs"
  value       = module.eventbridge.this_eventbridge_archive_arns
}

