output "eventbridge_bus_arn" {
  value = module.eventbridge.this_eventbridge_bus_arn
}

output "eventbridge_rule_ids" {
  value = module.eventbridge.this_eventbridge_rule_ids
}

output "eventbridge_rule_arns" {
  value = module.eventbridge.this_eventbridge_rule_arns
}
