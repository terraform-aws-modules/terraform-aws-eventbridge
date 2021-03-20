output "eventbridge_bus_arn" {
  description = ""
  value       = module.eventbridge.this_eventbridge_bus_arn
}

output "eventbridge_rule_ids" {
  description = ""
  value       = module.eventbridge.this_eventbridge_rule_ids
}

output "eventbridge_rule_arns" {
  description = ""
  value       = module.eventbridge.this_eventbridge_rule_arns
}
