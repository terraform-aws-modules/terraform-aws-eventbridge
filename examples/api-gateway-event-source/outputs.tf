output "this_eventbridge_bus_name" {
  description = "The EventBridge Bus Name"
  value       = module.eventbridge.this_eventbridge_bus_name
}

output "this_eventbridge_bus_arn" {
  description = "The EventBridge Bus Arn"
  value       = module.eventbridge.this_eventbridge_bus_arn
}
output "this_eventbridge_rule_ids" {
  description = "The EventBridge Rule IDs created"
  value       = module.eventbridge.this_eventbridge_rule_ids
}

output "this_eventbridge_rule_arns" {
  description = "The EventBridge Rule ARNs created"
  value       = module.eventbridge.this_eventbridge_rule_arns
}

output "eventbridge_role_arn" {
  description = "The ARN of the IAM role created for EventBridge"
  value       = module.eventbridge.eventbridge_role_arn
}

output "eventbridge_role_name" {
  description = "The name of the IAM role created for EventBridge"
  value       = module.eventbridge.eventbridge_role_name
}

output "apigateway_put_events_to_eventbridge_role_arn" {
  description = ""
  value       = module.apigateway_put_events_to_eventbridge_role.this_iam_role_arn
}

