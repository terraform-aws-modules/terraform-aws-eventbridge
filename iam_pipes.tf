locals {
  # Filter out pipes where role_arn was already specified.
  role_for_pipes = {
    for k, v in local.eventbridge_pipes :
    v.name => merge(v, {
      role_name = try(v.role_name_prefix, v.name),
      service_integrations = {
        # Source only
        dynamodb = {
          values            = [v.source]
          matching_services = ["dynamodb"]
        },
        mq = {
          values            = [v.source]
          matching_services = ["mq"]
        },
        msk = {
          values            = [v.source],
          matching_services = ["kafka"]
        },
        sqs_source = {
          values            = [v.source],
          matching_services = ["sqs"]
        },
        kinesis_source = {
          values            = [v.source],
          matching_services = ["kinesis"]
        },

        # Enrichment / Target
        lambda = {
          values            = [v.target, try(aws_cloudwatch_event_api_destination.this[v.enrichment].arn, null)],
          matching_services = ["lambda"]
        },
        step_functions = {
          values            = [v.target, try(aws_cloudwatch_event_api_destination.this[v.enrichment].arn, null)],
          matching_services = ["states"]
        },
        api_gateway = {
          values            = [v.target, try(aws_cloudwatch_event_api_destination.this[v.enrichment].arn, null)],
          matching_services = ["execute-api"]
        },
        api_destination = { # Sample ARN of API Destination: "arn:aws:events:eu-west-1:835367859851:api-destination/proud-worm-external"
          values                       = [v.target, try(aws_cloudwatch_event_api_destination.this[v.enrichment].arn, null)],
          matching_services            = ["events"]
          matching_resource_startswith = "api-destination/"
        },

        # Target
        sqs_target = {
          values            = [v.target],
          matching_services = ["sqs"]
        },
        kinesis_target = {
          values            = [v.target],
          matching_services = ["kinesis"]
        },
        batch = {
          values            = [v.target],
          matching_services = ["batch"]
        },
        logs = {
          values            = [v.target],
          matching_services = ["logs"]
        },
        ecs = {
          values            = [replace(v.target, "/:\\d+$/", ":*")],
          matching_services = ["ecs"]
        },
        ecs_iam_passrole = {
          values            = ["*"],
          matching_values   = [v.target],
          matching_services = ["ecs"]
        },
        eventbridge = { # Sample ARN of EventBridge Bus: "arn:aws:events:eu-west-1:835367859851:event-bus/default"
          values                       = [v.target],
          matching_services            = ["events"]
          matching_resource_startswith = "event-bus/"
        },
        firehose = {
          values            = [v.target],
          matching_services = ["firehose"]
        },
        inspector = {
          values            = [v.target],
          matching_services = ["inspector"]
        },
        redshift = {
          values            = [v.target],
          matching_services = ["redshift"]
        },
        sagemaker = {
          values            = [v.target],
          matching_services = ["sagemaker"]
        },
        sns = {
          values            = [v.target],
          matching_services = ["sns"]
        },

        # Dead-letter queue (DLQ) for DynamoDB Streams and Kinesis Streams
        sqs_dlq = {
          values = [
            try(v.source_parameters.dynamodb_stream_parameters.dead_letter_config.arn, null),
            try(v.source_parameters.kinesis_stream_parameters.dead_letter_config.arn, null)
          ],
          matching_services = ["sqs"]
        },

      }
    })
    if local.create_role_for_pipes && try(v.create_role, true)
  }

  service_integrations_for_pipes = {
    for k, v in local.role_for_pipes :
    k => {
      for s_k, s_v in v.service_integrations :
      # s_k - is a key in aws_service_policies
      # value - is a list of matched ARNs
      # Sample ARNs:
      # arn:aws:kafka:eu-west-1:835367859851:cluster/cluster-name/cluster-uuid
      # arn:aws:events:eu-west-1:835367859851:api-destination/proud-worm-external

      s_k => [
        for arn in compact(try(s_v.matching_values, s_v.values)) : arn
        if(arn == "*" || try(contains(s_v.matching_services, split(":", arn)[2]), true)) && try(startswith(split(":", arn)[5], s_v.matching_resource_startswith), true)
      ]
    }
  }

  # Map of all available IAM policies constructs for AWS services
  #
  # See more - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes-permissions.html
  #
  # Notes:
  # * `effect` - "Allow" or "Deny" in policy statement (default: Allow)
  # * `actions` - list of actions in policy statement
  # * `condition` - list of condition in policy statement

  aws_service_policies = {
    sqs_source = {
      actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
    }

    sqs_target = {
      actions = [
        "sqs:SendMessage"
      ]
    }

    sqs_dlq = {
      actions = [
        "sqs:SendMessage" # ??? Not sure which IAM policy to use for DLQ
      ]
    }

    dynamodb = {
      actions = [
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
      ]
    }

    kinesis_source = {
      actions = [
        "kinesis:DescribeStream",
        "kinesis:DescribeStreamSummary",
        "kinesis:GetRecords",
        "kinesis:GetShardIterator",
        "kinesis:ListShards",
        "kinesis:ListStreams",
        "kinesis:SubscribeToShard"
      ]
    }

    kinesis_target = {
      actions = [
        "kinesis:PutRecord"
      ]
    }

    mq = {
      actions = [
        "mq:DescribeBroker",
        "secretsmanager:GetSecretValue",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }

    msk = {
      # Read this for more: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes-msk.html#pipes-msk-permissions-iam-policy
      actions = [
        "kafka:DescribeClusterV2",
        "kafka:GetBootstrapBrokers",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }

    lambda = {
      actions = [
        "lambda:InvokeFunction"
      ]
    }

    step_functions = {
      actions = [
        "states:StartExecution",
        "states:StartSyncExecution"
      ]
    }

    api_gateway = {
      actions = [
        "execute-api:Invoke"
      ]
    }

    api_destination = {
      actions = [
        "events:InvokeApiDestination"
      ]
    }

    batch = {
      actions = [
        "batch:SubmitJob"
      ]
    }

    logs = {
      actions = [
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }

    ecs = {
      actions = [
        "ecs:RunTask",
        "ecs:TagResource"
      ]
    }

    ecs_iam_passrole = {
      actions = [
        "iam:PassRole"
      ]
    }

    eventbridge = {
      actions = [
        "events:PutEvents"
      ]
    }

    firehose = {
      actions = [
        "firehose:PutRecord"
      ]
    }

    inspector = {
      actions = [
        "inspector:CreateAssessmentTemplate" # ???
      ]
    }

    redshift = {
      actions = [
        "redshift-data:ExecuteStatement" # ???
      ]
    }

    sagemaker = {
      actions = [
        "sagemaker:CreatePipeline" # ???
      ]
    }

    sns = {
      actions = [
        "sns:Publish"
      ]
    }
  }
}

#################################
# IAM role for EventBridge Pipes
#################################

data "aws_iam_policy_document" "assume_role_pipe" {
  for_each = local.role_for_pipes

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["pipes.${data.aws_partition.current.dns_suffix}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:pipes:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:pipe/${each.value.Name}"]
    }
  }
}

resource "aws_iam_role" "eventbridge_pipe" {
  for_each = local.role_for_pipes

  name_prefix = each.value.role_name

  description           = try(each.value.role_description, null)
  path                  = try(each.value.role_path, null)
  force_detach_policies = try(each.value.role_force_detach_policies, null)
  permissions_boundary  = try(each.value.role_permissions_boundary, null)
  assume_role_policy    = data.aws_iam_policy_document.assume_role_pipe[each.key].json

  tags = merge({ Name = each.value.role_name }, try(each.value.role_tags, {}), var.tags)
}


##############################
# Predefined service policies
##############################

data "aws_iam_policy_document" "service" {
  for_each = { for k, v in local.service_integrations_for_pipes : k => v if try(v.attach_policies_for_integrations, true) }

  dynamic "statement" {
    for_each = { for s_k, s_v in each.value : s_k => s_v if length(compact(s_v)) > 0 }

    content {
      effect    = lookup(local.aws_service_policies[statement.key], "effect", "Allow")
      sid       = replace(replace(title(replace("${each.key}${title(statement.key)}", "/[_-]/", " ")), " ", ""), "/[^0-9A-Za-z]*/", "")
      actions   = local.aws_service_policies[statement.key]["actions"]
      resources = tolist(statement.value)

      dynamic "condition" {
        for_each = lookup(local.aws_service_policies[statement.key], "condition", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "service" {
  for_each = { for k, v in local.role_for_pipes : k => v if try(v.attach_policies_for_integrations, true) }

  name   = "${aws_iam_role.eventbridge_pipe[each.key].name}-${each.key}"
  policy = data.aws_iam_policy_document.service[each.key].json
}

resource "aws_iam_policy_attachment" "service" {
  for_each = { for k, v in local.role_for_pipes : k => v if try(v.attach_policies_for_integrations, true) }

  name       = "${aws_iam_role.eventbridge_pipe[each.key].name}-${each.key}"
  roles      = [aws_iam_role.eventbridge_pipe[each.key].name]
  policy_arn = aws_iam_policy.service[each.key].arn
}
