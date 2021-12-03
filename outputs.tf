# EventBridge Bus
output "eventbridge_bus_name" {
  description = "The EventBridge Bus Name"
  value       = var.bus_name
}

output "eventbridge_bus_arn" {
  description = "The EventBridge Bus Arn"
  value       = element(concat(aws_cloudwatch_event_bus.this.*.arn, [""]), 0)
}

# EventBridge Archive
output "eventbridge_archive_arns" {
  description = "The EventBridge Archive Arns created"
  value       = { for v in aws_cloudwatch_event_archive.this : v.name => v.arn }
}

# EventBridge Permission
output "eventbridge_permission_ids" {
  description = "The EventBridge Permission Arns created"
  value       = { for k, v in aws_cloudwatch_event_permission.this : k => v.id }
}

# EventBridge Connection
output "eventbridge_connection_ids" {
  description = "The EventBridge Connection IDs created"
  value       = { for k, v in aws_cloudwatch_event_connection.this : k => v.id }
}

output "eventbridge_connection_arns" {
  description = "The EventBridge Connection Arns created"
  value       = { for k, v in aws_cloudwatch_event_connection.this : k => v.arn }
}

# EventBridge Destination
output "eventbridge_api_destination_arns" {
  description = "The EventBridge API Destination ARNs created"
  value       = { for k, v in aws_cloudwatch_event_api_destination.this : k => v.id }
}

# EventBridge Rule
output "eventbridge_rule_ids" {
  description = "The EventBridge Rule IDs created"
  value       = var.create && var.create_rules ? { for p in sort(keys(var.rules)) : p => aws_cloudwatch_event_rule.this[p].id } : {}
}

output "eventbridge_rule_arns" {
  description = "The EventBridge Rule ARNs created"
  value       = var.create && var.create_rules ? { for p in sort(keys(var.rules)) : p => aws_cloudwatch_event_rule.this[p].arn } : {}
}

# IAM Role
output "eventbridge_role_arn" {
  description = "The ARN of the IAM role created for EventBridge"
  value       = element(concat(aws_iam_role.eventbridge.*.arn, [""]), 0)
}

output "eventbridge_role_name" {
  description = "The name of the IAM role created for EventBridge"
  value       = element(concat(aws_iam_role.eventbridge.*.name, [""]), 0)
}
