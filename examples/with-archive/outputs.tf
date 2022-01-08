output "eventbridge_bus_arn" {
  description = "The EventBridge Bus ARN"
  value       = module.eventbridge.eventbridge_bus_arn
}

output "eventbridge_archive_arns" {
  description = "The EventBridge Archive ARNs"
  value       = module.eventbridge.eventbridge_archive_arns
}
