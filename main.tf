data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  eventbridge_rules = flatten([
    for index, rule in var.rules :
    merge(rule, {
      "name" = index
      "Name" = var.append_rule_postfix ? "${replace(index, "_", "-")}-rule" : index
    })
  ])
  eventbridge_targets = flatten([
    for index, rule in var.rules : [
      for target in var.targets[index] :
      merge(target, {
        "rule" = index
        "Name" = var.append_rule_postfix ? "${replace(index, "_", "-")}-rule" : index
      })
    ] if length(var.targets) != 0
  ])
  eventbridge_connections = flatten([
    for index, conn in var.connections :
    merge(conn, {
      "name" = index
      "Name" = var.append_connection_postfix ? "${replace(index, "_", "-")}-connection" : index
    })
  ])
  eventbridge_api_destinations = flatten([
    for index, dest in var.api_destinations :
    merge(dest, {
      "name" = index
      "Name" = var.append_destination_postfix ? "${replace(index, "_", "-")}-destination" : index
    })
  ])
  eventbridge_schedule_groups = {
    for index, group in var.schedule_groups :
    index => merge(group, {
      "Name" = var.append_schedule_group_postfix ? "${replace(index, "_", "-")}-group" : index
    })
  }
  eventbridge_schedules = flatten([
    for index, sched in var.schedules :
    merge(sched, {
      "name" = index
      "Name" = var.append_schedule_postfix ? "${replace(index, "_", "-")}-schedule" : index
    })
  ])
  eventbridge_pipes = flatten([
    for index, pipe in var.pipes :
    merge(pipe, {
      "name" = index
      "Name" = var.append_pipe_postfix ? "${replace(index, "_", "-")}-pipe" : index
    })
  ])
}

data "aws_cloudwatch_event_bus" "this" {
  count = var.create && var.create_bus ? 0 : 1

  name = var.bus_name
}

resource "aws_cloudwatch_event_bus" "this" {
  count = var.create && var.create_bus ? 1 : 0

  name              = var.bus_name
  event_source_name = try(var.event_source_name, null)

  tags = var.tags
}

resource "aws_schemas_discoverer" "this" {
  count = var.create && var.create_schemas_discoverer ? 1 : 0

  source_arn  = var.create_bus ? aws_cloudwatch_event_bus.this[0].arn : data.aws_cloudwatch_event_bus.this[0].arn
  description = var.schemas_discoverer_description

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for k, v in local.eventbridge_rules : v.name => v if var.create && var.create_rules }

  name        = each.value.Name
  name_prefix = lookup(each.value, "name_prefix", null)

  event_bus_name = var.create_bus ? aws_cloudwatch_event_bus.this[0].name : var.bus_name

  description         = lookup(each.value, "description", null)
  event_pattern       = lookup(each.value, "event_pattern", null)
  schedule_expression = lookup(each.value, "schedule_expression", null)
  role_arn            = lookup(each.value, "role_arn", false) ? aws_iam_role.eventbridge[0].arn : null
  state               = try(each.value.enabled ? "ENABLED" : "DISABLED", tobool(each.value.state) ? "ENABLED" : "DISABLED", upper(each.value.state), null)

  tags = merge(var.tags, {
    Name = each.value.Name
  })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = { for k, v in local.eventbridge_targets : v.name => v if var.create && var.create_targets }

  event_bus_name = var.create_bus ? aws_cloudwatch_event_bus.this[0].name : var.bus_name

  rule = each.value.Name
  arn  = lookup(each.value, "destination", null) != null ? aws_cloudwatch_event_api_destination.this[each.value.destination].arn : each.value.arn

  role_arn = can(length(each.value.attach_role_arn) > 0) ? each.value.attach_role_arn : (try(each.value.attach_role_arn, null) == true ? aws_iam_role.eventbridge[0].arn : null)

  target_id  = lookup(each.value, "target_id", null)
  input      = lookup(each.value, "input", null)
  input_path = lookup(each.value, "input_path", null)

  dynamic "run_command_targets" {
    for_each = try([each.value.run_command_targets], [])

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
      group                   = lookup(ecs_target.value, "group", null)
      launch_type             = lookup(ecs_target.value, "launch_type", null)
      platform_version        = lookup(ecs_target.value, "platform_version", null)
      task_count              = lookup(ecs_target.value, "task_count", null)
      task_definition_arn     = ecs_target.value.task_definition_arn
      enable_ecs_managed_tags = lookup(ecs_target.value, "enable_ecs_managed_tags", null)
      enable_execute_command  = lookup(ecs_target.value, "enable_execute_command", null)
      propagate_tags          = lookup(ecs_target.value, "propagate_tags", null)
      tags                    = lookup(ecs_target.value, "tags", null)

      dynamic "network_configuration" {
        for_each = lookup(ecs_target.value, "network_configuration", null) != null ? [
          ecs_target.value.network_configuration
        ] : []

        content {
          subnets          = lookup(network_configuration.value, "subnets", null)
          security_groups  = lookup(network_configuration.value, "security_groups", null)
          assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
        }
      }

      dynamic "capacity_provider_strategy" {
        for_each = try(ecs_target.value.capacity_provider_strategy, [])

        content {
          capacity_provider = try(capacity_provider_strategy.value.capacity_provider, null)
          weight            = try(capacity_provider_strategy.value.weight, null)
          base              = try(capacity_provider_strategy.value.base, null)
        }
      }

      dynamic "ordered_placement_strategy" {
        for_each = try(ecs_target.value.ordered_placement_strategy, [])

        content {
          type  = try(ordered_placement_strategy.value.type, null)
          field = try(ordered_placement_strategy.value.field, null)
        }
      }

      dynamic "placement_constraint" {
        for_each = try(ecs_target.value.placement_constraint, [])

        content {
          type       = try(placement_constraint.value.type, null)
          expression = try(placement_constraint.value.expression, null)
        }
      }
    }
  }

  dynamic "batch_target" {
    for_each = lookup(each.value, "batch_target", null) != null ? [
      each.value.batch_target
    ] : []

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
      input_paths    = try(input_transformer.value.input_paths, null)
      input_template = chomp(input_transformer.value.input_template)
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

  name             = lookup(each.value, "name", each.key)
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
  event_bus_name = try(each.value["event_bus_name"], aws_cloudwatch_event_bus.this[0].name, var.bus_name, null)

  dynamic "condition" {
    for_each = try([each.value.condition_org], [])

    content {
      key   = "aws:PrincipalOrgID"
      type  = "StringEquals"
      value = condition.value
    }
  }
}

resource "aws_cloudwatch_event_connection" "this" {
  for_each = { for k, v in local.eventbridge_connections : v.name => v if var.create && var.create_connections }

  name               = each.value.Name
  description        = lookup(each.value, "description", null)
  authorization_type = each.value.authorization_type

  dynamic "auth_parameters" {
    for_each = [each.value.auth_parameters]

    content {
      dynamic "api_key" {
        for_each = lookup(each.value.auth_parameters, "api_key", null) != null ? [
          each.value.auth_parameters.api_key
        ] : []

        content {
          key   = api_key.value.key
          value = api_key.value.value
        }
      }

      dynamic "basic" {
        for_each = lookup(each.value.auth_parameters, "basic", null) != null ? [
          each.value.auth_parameters.basic
        ] : []

        content {
          username = basic.value.username
          password = basic.value.password
        }
      }

      dynamic "oauth" {
        for_each = lookup(each.value.auth_parameters, "oauth", null) != null ? [
          each.value.auth_parameters.oauth
        ] : []

        content {
          authorization_endpoint = oauth.value.authorization_endpoint
          http_method            = oauth.value.http_method

          dynamic "client_parameters" {
            for_each = [each.value.auth_parameters.oauth.client_parameters]

            content {
              client_id     = client_parameters.value.client_id
              client_secret = client_parameters.value.client_secret
            }
          }

          dynamic "oauth_http_parameters" {
            for_each = lookup(each.value.auth_parameters.oauth, "oauth_http_parameters", null) != null ? [
              each.value.auth_parameters.oauth.oauth_http_parameters
            ] : []

            content {
              dynamic "body" {
                for_each = lookup(each.value.auth_parameters.oauth.oauth_http_parameters, "body", [])

                content {
                  key             = body.value.key
                  value           = body.value.value
                  is_value_secret = lookup(body.value, "is_value_secret", null)
                }
              }

              dynamic "header" {
                for_each = lookup(each.value.auth_parameters.oauth.oauth_http_parameters, "header", [])

                content {
                  key             = header.value.key
                  value           = header.value.value
                  is_value_secret = lookup(header.value, "is_value_secret", null)
                }
              }

              dynamic "query_string" {
                for_each = lookup(each.value.auth_parameters.oauth.oauth_http_parameters, "query_string", [])

                content {
                  key             = query_string.value.key
                  value           = query_string.value.value
                  is_value_secret = lookup(query_string.value, "is_value_secret", null)
                }
              }
            }
          }
        }
      }

      dynamic "invocation_http_parameters" {
        for_each = lookup(each.value.auth_parameters, "invocation_http_parameters", null) != null ? [
          each.value.auth_parameters.invocation_http_parameters
        ] : []

        content {
          dynamic "body" {
            for_each = lookup(each.value.auth_parameters.invocation_http_parameters, "body", [])

            content {
              key             = body.value.key
              value           = body.value.value
              is_value_secret = lookup(body.value, "is_value_secret", null)
            }
          }

          dynamic "header" {
            for_each = lookup(each.value.auth_parameters.invocation_http_parameters, "header", [])

            content {
              key             = header.value.key
              value           = header.value.value
              is_value_secret = lookup(header.value, "is_value_secret", null)
            }
          }

          dynamic "query_string" {
            for_each = lookup(each.value.auth_parameters.invocation_http_parameters, "query_string", [])

            content {
              key             = query_string.value.key
              value           = query_string.value.value
              is_value_secret = lookup(query_string.value, "is_value_secret", null)
            }
          }
        }
      }
    }
  }
}

resource "aws_cloudwatch_event_api_destination" "this" {
  for_each = { for k, v in local.eventbridge_api_destinations : v.name => v if var.create && var.create_api_destinations }

  name                             = each.value.Name
  description                      = lookup(each.value, "description", null)
  invocation_endpoint              = each.value.invocation_endpoint
  http_method                      = each.value.http_method
  invocation_rate_limit_per_second = lookup(each.value, "invocation_rate_limit_per_second", null)
  connection_arn                   = try(aws_cloudwatch_event_connection.this[each.value.connection_name].arn, aws_cloudwatch_event_connection.this[each.value.name].arn)
}

resource "aws_scheduler_schedule_group" "this" {
  for_each = { for k, v in local.eventbridge_schedule_groups : k => v if var.create && var.create_schedule_groups }

  name        = lookup(each.value, "name_prefix", null) == null ? try(each.value.name, each.key) : null
  name_prefix = lookup(each.value, "name_prefix", null) != null ? each.value.name_prefix : null

  tags = lookup(each.value, "tags", {})

  timeouts {
    create = try(var.schedule_group_timeouts.create, null)
    delete = try(var.schedule_group_timeouts.delete, null)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_scheduler_schedule" "this" {
  for_each = { for k, v in local.eventbridge_schedules : v.name => v if var.create && var.create_schedules }

  name        = each.value.Name
  name_prefix = lookup(each.value, "name_prefix", null)
  description = lookup(each.value, "description", null)
  group_name  = try(aws_scheduler_schedule_group.this[each.value.group_name].id, lookup(each.value, "group_name", null))

  start_date = lookup(each.value, "start_date", null)
  end_date   = lookup(each.value, "end_date", null)

  kms_key_arn = lookup(each.value, "kms_key_arn", null)

  schedule_expression          = each.value.schedule_expression
  schedule_expression_timezone = lookup(each.value, "timezone", null)

  state = lookup(each.value, "state", true) ? "ENABLED" : "DISABLED"

  flexible_time_window {
    maximum_window_in_minutes = lookup(each.value, "maximum_window_in_minutes", null)
    mode                      = lookup(each.value, "use_flexible_time_window", false) ? "FLEXIBLE" : "OFF"
  }

  target {
    arn      = each.value.arn
    role_arn = can(length(each.value.role_arn) > 0) ? each.value.role_arn : aws_iam_role.eventbridge[0].arn

    input = lookup(each.value, "input", null)

    dynamic "dead_letter_config" {
      for_each = lookup(each.value, "dead_letter_arn", null) != null ? [true] : []

      content {
        arn = each.value.dead_letter_arn
      }
    }

    dynamic "ecs_parameters" {
      for_each = lookup(each.value, "ecs_parameters", null) != null ? [
        each.value.ecs_parameters
      ] : []

      content {
        task_definition_arn     = ecs_parameters.value.task_definition_arn
        enable_ecs_managed_tags = lookup(ecs_parameters.value, "enable_ecs_managed_tags", null)
        enable_execute_command  = lookup(ecs_parameters.value, "enable_execute_command", null)
        group                   = lookup(ecs_parameters.value, "group", null)
        launch_type             = lookup(ecs_parameters.value, "launch_type", null)
        platform_version        = lookup(ecs_parameters.value, "platform_version", null)
        propagate_tags          = lookup(ecs_parameters.value, "propagate_tags", null)
        reference_id            = lookup(ecs_parameters.value, "reference_id", null)
        tags                    = lookup(ecs_parameters.value, "tags", null)
        task_count              = lookup(ecs_parameters.value, "task_count", null)

        dynamic "capacity_provider_strategy" {
          for_each = lookup(ecs_parameters.value, "capacity_provider_strategy", null) != null ? [
            ecs_parameters.value.capacity_provider_strategy
          ] : []

          content {
            capacity_provider = capacity_provider_strategy.value.capacity_provider
            base              = lookup(capacity_provider_strategy.value, "base", null)
            weight            = lookup(capacity_provider_strategy.value, "weight", null)
          }
        }

        dynamic "network_configuration" {
          for_each = lookup(ecs_parameters.value, "network_configuration", null) != null ? [
            ecs_parameters.value.network_configuration
          ] : []

          content {
            subnets          = lookup(network_configuration.value, "subnets", null)
            security_groups  = lookup(network_configuration.value, "security_groups", null)
            assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
          }
        }

        dynamic "placement_constraints" {
          for_each = lookup(ecs_parameters.value, "placement_constraints", null) != null ? [
            ecs_parameters.value.placement_constraints
          ] : []

          content {
            type       = placement_constraints.value.type
            expression = lookup(placement_constraints.value, "expression", null)
          }
        }

        dynamic "placement_strategy" {
          for_each = lookup(ecs_parameters.value, "placement_strategy", null) != null ? [
            ecs_parameters.value.placement_strategy
          ] : []

          content {
            type  = placement_strategy.value.type
            field = lookup(placement_strategy.value, "field", null)
          }
        }
      }
    }

    dynamic "eventbridge_parameters" {
      for_each = lookup(each.value, "eventbridge_parameters", null) != null ? [
        each.value.eventbridge_parameters
      ] : []

      content {
        detail_type = eventbridge_parameters.value.detail_type
        source      = eventbridge_parameters.value.source
      }
    }

    dynamic "kinesis_parameters" {
      for_each = lookup(each.value, "kinesis_parameters", null) != null ? [true] : []

      content {
        partition_key = kinesis_parameters.value.partition_key
      }
    }

    dynamic "sagemaker_pipeline_parameters" {
      for_each = lookup(each.value, "sagemaker_pipeline_parameters", null) != null ? [
        each.value.sagemaker_pipeline_parameters
      ] : []

      content {
        dynamic "pipeline_parameter" {
          for_each = lookup(sagemaker_pipeline_parameters, "pipeline_parameter", null) != null ? [
            sagemaker_pipeline_parameters.value.pipeline_parameter
          ] : []

          content {
            name  = pipeline_parameter.value.name
            value = pipeline_parameter.value.value
          }
        }
      }
    }

    dynamic "sqs_parameters" {
      for_each = lookup(each.value, "message_group_id", null) != null ? [true] : []

      content {
        message_group_id = each.value.message_group_id
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
  }
}

resource "aws_pipes_pipe" "this" {
  for_each = { for k, v in local.eventbridge_pipes : v.name => v if local.create_pipes }

  name = each.value.Name

  role_arn = try(each.value.role_arn, aws_iam_role.eventbridge_pipe[each.key].arn)

  source = each.value.source
  target = each.value.target

  description   = lookup(each.value, "description", null)
  desired_state = lookup(each.value, "desired_state", null)

  dynamic "source_parameters" {
    for_each = try([each.value.source_parameters], [])

    content {
      dynamic "filter_criteria" {
        for_each = try([source_parameters.value.filter_criteria], [])

        content {
          dynamic "filter" {
            for_each = try(filter_criteria.value, [])

            content {
              pattern = filter.value.pattern
            }
          }
        }
      }

      dynamic "sqs_queue_parameters" {
        for_each = try([source_parameters.value.sqs_queue_parameters], [])

        content {
          batch_size                         = try(sqs_queue_parameters.value.batch_size, null)
          maximum_batching_window_in_seconds = try(sqs_queue_parameters.value.maximum_batching_window_in_seconds, null)
        }
      }

      dynamic "dynamodb_stream_parameters" {
        for_each = try([source_parameters.value.dynamodb_stream_parameters], [])

        content {
          batch_size                         = try(dynamodb_stream_parameters.value.batch_size, null)
          maximum_batching_window_in_seconds = try(dynamodb_stream_parameters.value.maximum_batching_window_in_seconds, null)
          maximum_record_age_in_seconds      = try(dynamodb_stream_parameters.value.maximum_record_age_in_seconds, null)
          maximum_retry_attempts             = try(dynamodb_stream_parameters.value.maximum_retry_attempts, null)
          on_partial_batch_item_failure      = try(dynamodb_stream_parameters.value.on_partial_batch_item_failure, null)
          parallelization_factor             = try(dynamodb_stream_parameters.value.parallelization_factor, null)
          starting_position                  = try(dynamodb_stream_parameters.value.starting_position, null)

          dynamic "dead_letter_config" {
            for_each = try([dynamodb_stream_parameters.value.dead_letter_config], [])

            content {
              arn = dead_letter_config.value.arn
            }
          }
        }
      }

      dynamic "kinesis_stream_parameters" {
        for_each = try([source_parameters.value.kinesis_stream_parameters], [])

        content {
          batch_size                         = try(kinesis_stream_parameters.value.batch_size, null)
          maximum_batching_window_in_seconds = try(kinesis_stream_parameters.value.maximum_batching_window_in_seconds, null)
          maximum_record_age_in_seconds      = try(kinesis_stream_parameters.value.maximum_record_age_in_seconds, null)
          maximum_retry_attempts             = try(kinesis_stream_parameters.value.maximum_retry_attempts, null)
          on_partial_batch_item_failure      = try(kinesis_stream_parameters.value.on_partial_batch_item_failure, null)
          parallelization_factor             = try(kinesis_stream_parameters.value.parallelization_factor, null)
          starting_position                  = try(kinesis_stream_parameters.value.starting_position, null)
          starting_position_timestamp        = try(kinesis_stream_parameters.value.starting_position_timestamp, null)

          dynamic "dead_letter_config" {
            for_each = try([kinesis_stream_parameters.value.dead_letter_config], [])

            content {
              arn = dead_letter_config.value.arn
            }
          }
        }
      }
    }
  }

  dynamic "target_parameters" {
    for_each = try([each.value.target_parameters], [])

    content {
      input_template = try(target_parameters.value.input_template, null)
      dynamic "sqs_queue_parameters" {
        for_each = try([target_parameters.value.sqs_queue_parameters], [])

        content {
          message_deduplication_id = try(sqs_queue_parameters.value.message_deduplication_id, null)
          message_group_id         = try(sqs_queue_parameters.value.message_group_id, null)
        }
      }

      dynamic "cloudwatch_logs_parameters" {
        for_each = try([target_parameters.value.cloudwatch_logs_parameters], [])

        content {
          log_stream_name = try(cloudwatch_logs_parameters.value.log_stream_name, null)
          timestamp       = try(cloudwatch_logs_parameters.value.timestamp, null)
        }
      }

      dynamic "lambda_function_parameters" {
        for_each = try([target_parameters.value.lambda_function_parameters], [])

        content {
          invocation_type = try(lambda_function_parameters.value.invocation_type, null)
        }
      }

      dynamic "step_function_state_machine_parameters" {
        for_each = try([target_parameters.value.step_function_state_machine_parameters], [])

        content {
          invocation_type = try(step_function_state_machine_parameters.value.invocation_type, null)
        }
      }

      dynamic "eventbridge_event_bus_parameters" {
        for_each = try([target_parameters.value.eventbridge_event_bus_parameters], [])

        content {
          detail_type = try(eventbridge_event_bus_parameters.value.detail_type, null)
          endpoint_id = try(eventbridge_event_bus_parameters.value.endpoint_id, null)
          resources   = try(eventbridge_event_bus_parameters.value.resources, null)
          source      = try(eventbridge_event_bus_parameters.value.source, null)
          time        = try(eventbridge_event_bus_parameters.value.time, null)
        }
      }

      dynamic "http_parameters" {
        for_each = try([target_parameters.value.http_parameters], [])

        content {
          header_parameters       = try(http_parameters.value.header_parameters, null)
          path_parameter_values   = try(http_parameters.value.path_parameter_values, null)
          query_string_parameters = try(http_parameters.value.query_string_parameters, null)
        }
      }
    }
  }

  enrichment = try(aws_cloudwatch_event_api_destination.this[each.value.enrichment].arn, each.value.enrichment, null)

  dynamic "enrichment_parameters" {
    for_each = try([each.value.enrichment_parameters], [])

    content {
      input_template = try(each.value.enrichment_parameters.input_template, null)

      dynamic "http_parameters" {
        for_each = try([each.value.enrichment_parameters.http_parameters], [])

        content {
          path_parameter_values   = try(http_parameters.value.path_parameter_values, null)
          header_parameters       = try(http_parameters.value.header_parameters, null)
          query_string_parameters = try(http_parameters.value.query_string_parameters, null)
        }
      }
    }
  }

  tags = merge(var.tags, try(each.value.tags, {}))
}
