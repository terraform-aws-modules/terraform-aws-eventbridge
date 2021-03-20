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
  count = var.create ? 1 : 0

  name = var.bus_name
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for rule in local.eventbridge_rules : rule.name => rule }

  name = "${each.value.name}-rule"

  event_bus_name = aws_cloudwatch_event_bus.this[0].name

  description         = lookup(each.value, "description", "")
  name_prefix         = lookup(each.value, "name_prefix", null)
  is_enabled          = lookup(each.value, "enabled", true)
  event_pattern       = lookup(each.value, "event_pattern", null)
  schedule_expression = lookup(each.value, "schedule_expression", null)

  depends_on = [aws_cloudwatch_event_bus.this[0]]

  tags = merge(var.tags, {
    Name = "${each.value.name}-rule"
  })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = { for target in local.eventbridge_targets : target.name => target }

  event_bus_name = aws_cloudwatch_event_bus.this[0].name

  rule = each.value.rule
  arn  = each.value.arn

  target_id  = lookup(each.value, "target_id", null)
  input      = lookup(each.value, "input", null)
  input_path = lookup(each.value, "input_path", null)
  role_arn   = aws_iam_role.eventbridge[0].arn

  dynamic "run_command_targets" {
    for_each = lookup(each.value, "run_command_targets", null) != null ? [true] : []
    content {
      key    = run_command_targets.value.key
      values = run_command_targets.value.values
    }
  }

  dynamic "ecs_target" {
    for_each = lookup(each.value, "ecs_target", null) != null ? [true] : []

    content {
      group       = lookup(ecs_target.value, "group", null)
      launch_type = lookup(ecs_target.value, "launch_type", null)
      # network_configuration = lookup(ecs_target.value, "network_configuration", null)
      platform_version    = lookup(ecs_target.value, "platform_version", null)
      task_count          = lookup(ecs_target.value, "task_count", null)
      task_definition_arn = ecs_target.value.task_definition_arn
    }
  }

  # dynamic "network_configuration" {
  # for_each = lookup(each.value, "network_configuration", null) != null ? [true] : []

  # content {
  # subnets          = network_configuration.value.subnets
  # security_groups  = lookup(network_configuration.value, "security_groups", null)
  # assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
  # }
  # }

  dynamic "batch_target" {
    for_each = lookup(each.value, "batch_target", null) != null ? [true] : []

    content {
      job_definition = batch_target.value.job_definition
      job_name       = batch_target.value.job_name
      array_size     = lookup(batch_target.value, "array_size", null)
      job_attempts   = lookup(batch_target.value, "job_attempts", null)
    }
  }

  dynamic "kinesis_target" {
    for_each = lookup(each.value, "kinesis_target", null) != null ? [true] : []

    content {
      partition_key_path = lookup(kinesis_target.value, "partition_key_path", null)
    }
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

  name             = "${aws_cloudwatch_event_bus.this[0].name}-archive"
  event_source_arn = aws_cloudwatch_event_bus.this[0].arn
  description      = lookup(var.archive_config, "description", null)
  event_pattern    = lookup(var.archive_config, "event_pattern", null)
  retention_days   = lookup(var.archive_config, "retention_days", null)
}

resource "aws_cloudwatch_event_permission" "this" {
  for_each = var.create_permissions ? {
    for permission in var.permissions : permission.statement_id => permission
  } : {}

  principal      = each.value.account_id
  statement_id   = each.value.statement_id
  event_bus_name = aws_cloudwatch_event_bus.this[0].name
}
