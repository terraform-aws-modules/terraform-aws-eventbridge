output "this_eventbridge_bus_arn" {
  description = "The EventBridge Bus Arn"
  value       = element(concat(aws_cloudwatch_event_bus.this.*.id, [""]), 0)
}

output "this_eventbridge_archive_arn" {
  description = "The EventBridge Archive Arn"
  value       = element(concat(aws_cloudwatch_event_archive.this.*.id, [""]), 0)
}

output "this_eventbridge_permission_ids" {
  description = "The Permission Arns"
  value       = { for k, v in aws_cloudwatch_event_permission.this : k => v.id }
}

output "this_eventbridge_rule_ids" {
  description = "IDs"
  value = {
    for p in sort(keys(var.rules)) : p => aws_cloudwatch_event_rule.this[p].id
  }
}

output "this_eventbridge_rule_arns" {
  description = "ARNs"
  value = {
    for p in sort(keys(var.rules)) : p => aws_cloudwatch_event_rule.this[p].arn
  }
}
