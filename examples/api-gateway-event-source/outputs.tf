output "eventbridge_bus_name" {
  description = "The EventBridge Bus Name"
  value       = module.eventbridge.eventbridge_bus_name
}

output "eventbridge_bus_arn" {
  description = "The EventBridge Bus Arn"
  value       = module.eventbridge.eventbridge_bus_arn
}
output "eventbridge_rule_ids" {
  description = "The EventBridge Rule IDs created"
  value       = module.eventbridge.eventbridge_rule_ids
}

output "eventbridge_rule_arns" {
  description = "The EventBridge Rule ARNs created"
  value       = module.eventbridge.eventbridge_rule_arns
}

output "eventbridge_role_arn" {
  description = "The ARN of the IAM role created for EventBridge"
  value       = module.eventbridge.eventbridge_role_arn
}

output "eventbridge_role_name" {
  description = "The name of the IAM role created for EventBridge"
  value       = module.eventbridge.eventbridge_role_name
}
