output "eventbridge_bus_arn" {
  description = ""
  value       = module.eventbridge.this_eventbridge_bus_arn
}

output "eventbridge_archive_arns" {
  description = ""
  value       = module.eventbridge.this_eventbridge_archive_arns
}

