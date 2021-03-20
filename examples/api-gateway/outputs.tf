output "apigateway_put_events_to_eventbridge_role_arn" {
  description = ""
  value       = module.apigateway_put_events_to_eventbridge_role.this_iam_role_arn
}

output "eventbridge_role_name" {
  description = ""
  value       = module.eventbridge.eventbridge_role_name
}
