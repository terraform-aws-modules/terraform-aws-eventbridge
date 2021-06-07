locals {
  eventbridge_rules = flatten([
    for index, rule in var.rules :
    merge(rule, {
      "name" = index
      "Name" = "${replace(index, "_", "-")}-rule"
    })
  ])
  eventbridge_targets = flatten([
    for index, rule in var.rules : [
      for target in var.targets[index] :
      merge(target, {
        "rule" = index
        "Name" = "${replace(index, "_", "-")}-rule"
      })
    ] if length(var.targets) != 0
  ])
}

resource "aws_cloudwatch_event_bus" "this" {
  count = var.create && var.create_bus ? 1 : 0

  name = var.bus_name
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.create && var.create_rules ? {
    for rule in local.eventbridge_rules : rule.name => rule
  } : {}

  name        = each.value.Name
  name_prefix = lookup(each.value, "name_prefix", null)

  event_bus_name = var.create_bus ? aws_cloudwatch_event_bus.this[0].name : "default"

  description         = lookup(each.value, "description", null)
  is_enabled          = lookup(each.value, "enabled", true)
  event_pattern       = lookup(each.value, "event_pattern", null)
  schedule_expression = lookup(each.value, "schedule_expression", null)
  role_arn            = lookup(each.value, "role_arn", false) ? aws_iam_role.eventbridge[0].arn : null

  tags = merge(var.tags, {
    Name = each.value.Name
  })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = var.create && var.create_targets ? {
    for target in local.eventbridge_targets : target.name => target
  } : {}

  event_bus_name = var.create_bus ? aws_cloudwatch_event_bus.this[0].name : "default"

  rule = each.value.Name
  arn  = each.value.arn

  role_arn   = lookup(each.value, "attach_role_arn", null) != null ? try(aws_iam_role.eventbridge[0].arn, "") : null
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
    for_each = lookup(each.value, "ecs_target", null) != null ? [
      each.value.ecs_target
    ] : []

    content {
      group               = lookup(ecs_target.value, "group", null)
      launch_type         = lookup(ecs_target.value, "launch_type", null)
      platform_version    = lookup(ecs_target.value, "platform_version", null)
      task_count          = lookup(ecs_target.value, "task_count", null)
      task_definition_arn = lookup(ecs_target.value, "task_definition_arn", null)

      dynamic "network_configuration" {
        for_each = lookup(each.value.ecs_target, "network_configuration", null) != null ? [
          each.value.ecs_target.network_configuration
        ] : []

        content {
          subnets          = lookup(network_configuration.value, "subnets", null)
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

  dynamic "http_target" {
    for_each = lookup(each.value, "http_target", null) != null ? [
      each.value.http_target
    ] : []

    content {
      path_parameter_values   = lookup(http_target.value, "path_parameter_values", null)
      query_string_parameters = lookup(http_target.value, "query_string_parameters", null)
      header_parameters       = lookup(http_target.value, "header_parameters", null)
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

  depends_on = [aws_cloudwatch_event_rule.this]
}

resource "aws_cloudwatch_event_archive" "this" {
  for_each = var.create && var.create_archives ? var.archives : {}

  name             = each.key
  event_source_arn = try(each.value["event_source_arn"], aws_cloudwatch_event_bus.this[0].arn)

  description    = lookup(each.value, "description", null)
  event_pattern  = lookup(each.value, "event_pattern", null)
  retention_days = lookup(each.value, "retention_days", null)
}

resource "aws_cloudwatch_event_permission" "this" {
  for_each = var.create && var.create_permissions ? var.permissions : {}

  principal    = compact(split(" ", each.key))[0]
  statement_id = compact(split(" ", each.key))[1]

  action         = lookup(each.value, "action", null)
  event_bus_name = try(each.value["event_bus_name"], aws_cloudwatch_event_bus.this[0].name, null)
}
