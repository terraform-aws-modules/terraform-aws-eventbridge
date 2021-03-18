locals {
  eventbridge_rules = flatten([
    for index, rule in var.rules :
    merge(rule, { "name" = index })
  ])
  eventbridge_targets = flatten([
    for index, rule in var.rules : [
      for target in var.targets[index] :
      merge(target, { "rule" = index })
    ]
  ])
}

resource "aws_cloudwatch_event_bus" "this" {
  name = var.bus_name
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for rule in local.eventbridge_rules : rule.name => rule }

  name = "${each.value.name}-rule"

  event_bus_name = aws_cloudwatch_event_bus.this.name

  description         = lookup(each.value, "description", "")
  name_prefix         = lookup(each.value, "name_prefix", null)
  is_enabled          = lookup(each.value, "enabled", true)
  event_pattern       = lookup(each.value, "event_pattern", null)
  schedule_expression = lookup(each.value, "schedule_expression", null)

  depends_on = [aws_cloudwatch_event_bus.this]

  tags = merge(var.tags, {
    Name = "${each.value.name}-rule"
  })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = var.create_targets ? {
    for target in local.eventbridge_targets : target.name => target
  } : {}

  event_bus_name = aws_cloudwatch_event_bus.this.name

  target_id = each.value.name
  rule      = each.value.rule
  arn       = each.value.arn
  role_arn  = aws_iam_role.eventbridge[0].arn

  dead_letter_config {
    arn = each.value.dlq_arn
  }

  dynamic "sqs_target" {
    for_each = lookup(each.value, "sqs_target", null) != null ? [true] : []
    content {
      message_group_id = each.value.name
    }
  }

  dynamic "input_transformer" {
    for_each = lookup(each.value, "input_transformer", null) != null ? [
      each.value.input_transformer
    ] : []

    content {
      input_paths    = input_transformer.value.input_paths
      input_template = input_transformer.value.input_template
    }
  }
}

resource "aws_cloudwatch_event_archive" "this" {
  count = var.create_archive ? 1 : 0

  name             = "${aws_cloudwatch_event_bus.this.name}-archive"
  description      = lookup(var.archive_config, "description", "")
  retention_days   = lookup(var.archive_config, "retention_days", 0)
  event_pattern    = lookup(var.archive_config, "event_pattern", "")
  event_source_arn = aws_cloudwatch_event_bus.this.arn
}

resource "aws_cloudwatch_event_permission" "this" {
  for_each = var.create_permissions ? {
    for permission in var.permissions : permission.name => permission
  } : {}

  principal      = each.value.account_id
  statement_id   = each.value.name
  event_bus_name = aws_cloudwatch_event_bus.this.name
}
