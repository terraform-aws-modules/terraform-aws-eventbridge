# EventBridge Bus
output "eventbridge_bus_name" {
  description = "The EventBridge Bus Name"
  value       = var.bus_name
}

output "eventbridge_bus_arn" {
  description = "The EventBridge Bus ARN"
  value       = try(aws_cloudwatch_event_bus.this[0].arn, "")
}

# EventBridge Archive
output "eventbridge_archive_arns" {
  description = "The EventBridge Archive ARNs"
  value       = { for v in aws_cloudwatch_event_archive.this : v.name => v.arn }
}

# EventBridge Permission
output "eventbridge_permission_ids" {
  description = "The EventBridge Permission IDs"
  value       = { for k, v in aws_cloudwatch_event_permission.this : k => v.id }
}

# EventBridge Connection
output "eventbridge_connection_ids" {
  description = "The EventBridge Connection IDs"
  value       = { for k, v in aws_cloudwatch_event_connection.this : k => v.id }
}

output "eventbridge_connection_arns" {
  description = "The EventBridge Connection Arns"
  value       = { for k, v in aws_cloudwatch_event_connection.this : k => v.arn }
}

# EventBridge Destination
output "eventbridge_api_destination_arns" {
  description = "The EventBridge API Destination ARNs"
  value       = { for k, v in aws_cloudwatch_event_api_destination.this : k => v.arn }
}

# EventBridge Rule
output "eventbridge_rule_ids" {
  description = "The EventBridge Rule IDs"
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => v.id }
}

output "eventbridge_rule_arns" {
  description = "The EventBridge Rule ARNs"
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => v.arn }
}

# EventBridge Schedule Groups
output "eventbridge_schedule_group_ids" {
  description = "The EventBridge Schedule Group IDs"
  value       = { for k, v in aws_scheduler_schedule_group.this : k => v.id }
}

output "eventbridge_schedule_group_arns" {
  description = "The EventBridge Schedule Group ARNs"
  value       = { for k, v in aws_scheduler_schedule_group.this : k => v.arn }
}

output "eventbridge_schedule_group_states" {
  description = "The EventBridge Schedule Group states"
  value       = { for k, v in aws_scheduler_schedule_group.this : k => v.state }
}

# EventBridge Schedule
output "eventbridge_schedule_ids" {
  description = "The EventBridge Schedule IDs created"
  value       = { for k, v in aws_scheduler_schedule.this : k => v.id }
}

output "eventbridge_schedule_arns" {
  description = "The EventBridge Schedule ARNs created"
  value       = { for k, v in aws_scheduler_schedule.this : k => v.arn }
}

# IAM Role
output "eventbridge_role_arn" {
  description = "The ARN of the IAM role created for EventBridge"
  value       = try(aws_iam_role.eventbridge[0].arn, "")
}

output "eventbridge_role_name" {
  description = "The name of the IAM role created for EventBridge"
  value       = try(aws_iam_role.eventbridge[0].name, "")
}

# EventBridge Pipes
output "eventbridge_pipe_ids" {
  description = "The EventBridge Pipes IDs"
  value       = { for k, v in aws_pipes_pipe.this : k => v.id }
}

output "eventbridge_pipe_arns" {
  description = "The EventBridge Pipes ARNs"
  value       = { for k, v in aws_pipes_pipe.this : k => v.arn }
}

# IAM Role for EventBridge Pipes
output "eventbridge_pipe_role_arns" {
  description = "The ARNs of the IAM role created for EventBridge Pipes"
  value       = { for k, v in aws_iam_role.eventbridge_pipe : k => v.arn }
}

output "eventbridge_pipe_role_names" {
  description = "The names of the IAM role created for EventBridge Pipes"
  value       = { for k, v in aws_iam_role.eventbridge_pipe : k => v.name }
}

# Resources
output "eventbridge_bus" {
  description = "The EventBridge Bus created and their attributes"
  value       = aws_cloudwatch_event_bus.this
}

output "eventbridge_archives" {
  description = "The EventBridge Archives created and their attributes"
  value       = aws_cloudwatch_event_archive.this
}

output "eventbridge_permissions" {
  description = "The EventBridge Permissions created and their attributes"
  value       = aws_cloudwatch_event_permission.this
}

output "eventbridge_connections" {
  description = "The EventBridge Connections created and their attributes"
  value       = aws_cloudwatch_event_connection.this
  sensitive   = true
}

output "eventbridge_api_destinations" {
  description = "The EventBridge API Destinations created and their attributes"
  value       = aws_cloudwatch_event_api_destination.this
}

output "eventbridge_targets" {
  description = "The EventBridge Targets created and their attributes"
  value       = aws_cloudwatch_event_target.this
}

output "eventbridge_rules" {
  description = "The EventBridge Rules created and their attributes"
  value       = aws_cloudwatch_event_rule.this
}

output "eventbridge_schedule_groups" {
  description = "The EventBridge Schedule Groups created and their attributes"
  value       = aws_scheduler_schedule_group.this
}

output "eventbridge_schedules" {
  description = "The EventBridge Schedules created and their attributes"
  value       = aws_scheduler_schedule.this
}

output "eventbridge_pipes" {
  description = "The EventBridge Pipes created and their attributes"
  value       = aws_pipes_pipe.this
}

output "eventbridge_log_delivery_source" {
  description = "The EventBridge Bus CloudWatch Log Delivery Source created and their attributes"
  value       = aws_cloudwatch_log_delivery_source.this
}

# IAM Roles
output "eventbridge_pipes_iam_roles" {
  description = "The EventBridge Pipes IAM roles created and their attributes"
  value       = aws_iam_role.eventbridge_pipe
}

output "eventbridge_iam_roles" {
  description = "The EventBridge IAM roles created and their attributes"
  value       = aws_iam_role.eventbridge
}
