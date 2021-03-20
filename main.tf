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
  for_each = var.create && var.create_rules ? {
    for rule in local.eventbridge_rules : rule.name => rule
  } : {}

  name = "${replace(each.value.name, "_", "-")}-rule"

  event_bus_name = aws_cloudwatch_event_bus.this[0].name

  description         = lookup(each.value, "description", "")
  name_prefix         = lookup(each.value, "name_prefix", null)
  is_enabled          = lookup(each.value, "enabled", true)
  event_pattern       = lookup(each.value, "event_pattern", null)
  schedule_expression = lookup(each.value, "schedule_expression", null)

  depends_on = [aws_cloudwatch_event_bus.this[0]]

  tags = merge(var.tags, {
    Name = "${replace(each.value.name, "_", "-")}-rule"
  })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = var.create && var.create_targets ? {
    for target in local.eventbridge_targets : target.name => target
  } : toset({})

  event_bus_name = aws_cloudwatch_event_bus.this[0].name

  rule = "${replace(each.value.rule, "_", "-")}-rule"
  arn  = each.value.arn

  role_arn   = var.attach_target_role_arn ? aws_iam_role.eventbridge[0].arn : null
  target_id  = lookup(each.value, "target_id", null)
  input      = lookup(each.value, "input", null)
  input_path = lookup(each.value, "input_path", null)

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
      group               = lookup(ecs_target.value, "group", null)
      launch_type         = lookup(ecs_target.value, "launch_type", null)
      platform_version    = lookup(ecs_target.value, "platform_version", null)
      task_count          = lookup(ecs_target.value, "task_count", null)
      task_definition_arn = ecs_target.value.task_definition_arn

      dynamic "network_configuration" {
        for_each = lookup(ecs_target.value, "network_configuration", null) != null ? [true] : []

        content {
          subnets          = network_configuration.value.subnets
          security_groups  = lookup(network_configuration.value, "security_groups", null)
          assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
        }
      }
    }
  }

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
    for_each = lookup(each.value, "message_group_id", null) != null ? [true] : []

    content {
      message_group_id = each.value.message_group_id
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

  dynamic "dead_letter_config" {
    for_each = lookup(each.value, "dead_letter_arn", null) != null ? [true] : []

    content {
      arn = each.value.dead_letter_arn
    }
  }

  dynamic "retry_policy" {
    for_each = lookup(each.value, "retry_policy", null) != null ? [
      each.value.retry_policy
    ] : []

    content {
      maximum_event_age_in_seconds = retry_policy.value.maximum_event_age_in_seconds
      maximum_retry_attempts       = retry_policy.value.maximum_retry_attempts
    }
  }

  depends_on = [aws_cloudwatch_event_bus.this[0]]
}

resource "aws_cloudwatch_event_archive" "this" {
  for_each = var.create && var.create_archives ? {
    for k, v in var.archive_configs : k => v
  } : {}

  name             = each.value.name
  event_source_arn = aws_cloudwatch_event_bus.this[0].arn
  description      = lookup(each.value, "description", null)
  event_pattern    = lookup(each.value, "event_pattern", null)
  retention_days   = lookup(each.value, "retention_days", null)

  depends_on = [aws_cloudwatch_event_bus.this[0]]
}

resource "aws_cloudwatch_event_permission" "this" {
  for_each = var.create && var.create_permissions ? {
    for permission in var.permissions : permission.statement_id => permission
  } : {}

  principal      = each.value.account_id
  statement_id   = each.value.statement_id
  event_bus_name = aws_cloudwatch_event_bus.this[0].name

  depends_on = [aws_cloudwatch_event_bus.this[0]]
}
