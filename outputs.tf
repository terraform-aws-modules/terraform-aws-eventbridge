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
