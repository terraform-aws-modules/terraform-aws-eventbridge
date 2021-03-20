output "eventbridge_bus_arn" {
  description = "ARNs"
  value       = module.eventbridge.this_eventbridge_bus_arn
}

output "this_eventbridge_permission_ids" {
  description = "IDs"
  value       = module.eventbridge.this_eventbridge_permission_ids
}
