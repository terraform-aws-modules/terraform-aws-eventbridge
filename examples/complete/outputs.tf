output "eventbridge_bus_arn" {
  description = "The EventBridge Bus ARN"
  value       = module.eventbridge.eventbridge_bus_arn
}

output "eventbridge_rule_ids" {
  description = "The EventBridge Rule IDs"
  value       = module.eventbridge.eventbridge_rule_ids
}

output "eventbridge_rule_arns" {
  description = "The EventBridge Rule ARNs"
  value       = module.eventbridge.eventbridge_rule_arns
}

# Resources
output "eventbridge_bus" {
  description = "The EventBridge Bus created and their attributes"
  value       = module.eventbridge.eventbridge_bus
}

output "eventbridge_archives" {
  description = "The EventBridge Archives created and their attributes"
  value       = module.eventbridge.eventbridge_archives
}

output "eventbridge_permissions" {
  description = "The EventBridge Permissions created and their attributes"
  value       = module.eventbridge.eventbridge_permissions
}

output "eventbridge_connections" {
  description = "The EventBridge Connections created and their attributes"
  value       = module.eventbridge.eventbridge_connections
}

output "eventbridge_api_destinations" {
  description = "The EventBridge API Destinations created and their attributes"
  value       = module.eventbridge.eventbridge_api_destinations
}

output "eventbridge_targets" {
  description = "The EventBridge Targets created and their attributes"
  value       = module.eventbridge.eventbridge_targets
}

output "eventbridge_rules" {
  description = "The EventBridge Rules created and their attributes"
  value       = module.eventbridge.eventbridge_rules
}

output "eventbridge_schedule_groups" {
  description = "The EventBridge Schedule Groups created and their attributes"
  value       = module.eventbridge.eventbridge_schedule_groups
}

output "eventbridge_schedules" {
  description = "The EventBridge Schedules created and their attributes"
  value       = module.eventbridge.eventbridge_schedules
}

output "eventbridge_pipes" {
  description = "The EventBridge Pipes created and their attributes"
  value       = module.eventbridge.eventbridge_pipes
}

# IAM Roles
output "eventbridge_pipes_iam_roles" {
  description = "The EventBridge Pipes IAM roles created and their attributes"
  value       = module.eventbridge.eventbridge_pipes_iam_roles
}

output "eventbridge_iam_roles" {
  description = "The EventBridge IAM roles created and their attributes"
  value       = module.eventbridge.eventbridge_iam_roles
}
