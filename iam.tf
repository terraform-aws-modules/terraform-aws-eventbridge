locals {
  create_role = var.create && var.create_role

  # Defaulting to "*" (an invalid character for an IAM Role name) will cause an error when
  # attempting to plan if the role_name and bus_name are not set. This is a workaround
  # that will allow one to import resources without receiving an error from coalesce.
  # @see https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/83
  role_name = local.create_role ? coalesce(var.role_name, var.bus_name, "*") : null
}

###########
# IAM role
###########

data "aws_iam_policy_document" "assume_role" {
  count = local.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = distinct(concat(["events.amazonaws.com"], var.trusted_entities))
    }
  }
}

resource "aws_iam_role" "eventbridge" {
  count = local.create_role ? 1 : 0

  name                  = local.role_name
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json

  tags = merge({ Name = local.role_name }, var.tags, var.role_tags)
}

#####################
# Tracing with X-Ray
#####################

# Copying AWS managed policy to be able to attach the same policy with
# multiple roles without overwrites by another resources
data "aws_iam_policy" "tracing" {
  count = local.create_role && var.attach_tracing_policy ? 1 : 0

  arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_policy" "tracing" {
  count = local.create_role && var.attach_tracing_policy ? 1 : 0

  name   = "${local.role_name}-tracing"
  policy = data.aws_iam_policy.tracing[0].policy

  tags = merge({ Name = "${local.role_name}-tracing" }, var.tags)
}

resource "aws_iam_policy_attachment" "tracing" {
  count = local.create_role && var.attach_tracing_policy ? 1 : 0

  name       = "${local.role_name}-tracing"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.tracing[0].arn
}

##################
# Kinesis Config
##################

data "aws_iam_policy_document" "kinesis" {
  count = local.create_role && var.attach_kinesis_policy ? 1 : 0

  statement {
    sid       = "KinesisAccess"
    effect    = "Allow"
    actions   = ["kinesis:PutRecord"]
    resources = var.kinesis_target_arns
  }
}

resource "aws_iam_policy" "kinesis" {
  count = local.create_role && var.attach_kinesis_policy ? 1 : 0

  name   = "${local.role_name}-kinesis"
  policy = data.aws_iam_policy_document.kinesis[0].json

  tags = merge({ Name = "${local.role_name}-kinesis" }, var.tags)
}

resource "aws_iam_policy_attachment" "kinesis" {
  count = local.create_role && var.attach_kinesis_policy ? 1 : 0

  name       = "${local.role_name}-kinesis"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.kinesis[0].arn
}

##########################
# Kinesis Firehose Config
##########################

data "aws_iam_policy_document" "kinesis_firehose" {
  count = local.create_role && var.attach_kinesis_firehose_policy ? 1 : 0

  statement {
    sid       = "KinesisFirehoseAccess"
    effect    = "Allow"
    actions   = ["firehose:PutRecord"]
    resources = var.kinesis_firehose_target_arns
  }
}

resource "aws_iam_policy" "kinesis_firehose" {
  count = local.create_role && var.attach_kinesis_firehose_policy ? 1 : 0

  name   = "${local.role_name}-kinesis-firehose"
  policy = data.aws_iam_policy_document.kinesis_firehose[0].json

  tags = merge({ Name = "${local.role_name}-kinesis-firehose" }, var.tags)
}

resource "aws_iam_policy_attachment" "kinesis_firehose" {
  count = local.create_role && var.attach_kinesis_firehose_policy ? 1 : 0

  name       = "${local.role_name}-kinesis-firehose"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.kinesis_firehose[0].arn
}

#############
# SQS Config
#############

data "aws_iam_policy_document" "sqs" {
  count = local.create_role && var.attach_sqs_policy ? 1 : 0

  statement {
    sid    = "SQSAccess"
    effect = "Allow"
    actions = [
      "sqs:SendMessage*",
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = var.sqs_target_arns
  }
}

resource "aws_iam_policy" "sqs" {
  count = local.create_role && var.attach_sqs_policy ? 1 : 0

  name   = "${local.role_name}-sqs"
  policy = data.aws_iam_policy_document.sqs[0].json

  tags = merge({ Name = "${local.role_name}-sqs" }, var.tags)
}

resource "aws_iam_policy_attachment" "sqs" {
  count = local.create_role && var.attach_sqs_policy ? 1 : 0

  name       = "${local.role_name}-sqs"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.sqs[0].arn
}

#############
# ECS Config
#############

data "aws_iam_policy_document" "ecs" {
  count = local.create_role && var.attach_ecs_policy ? 1 : 0

  statement {
    sid       = "ECSAccess"
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = [for arn in var.ecs_target_arns : replace(arn, "/:\\d+$/", ":*")]
  }

  statement {
    sid       = "PassRole"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs" {
  count = local.create_role && var.attach_ecs_policy ? 1 : 0

  name   = "${local.role_name}-ecs"
  policy = data.aws_iam_policy_document.ecs[0].json

  tags = merge({ Name = "${local.role_name}-ecs" }, var.tags)
}

resource "aws_iam_policy_attachment" "ecs" {
  count = local.create_role && var.attach_ecs_policy ? 1 : 0

  name       = "${local.role_name}-ecs"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.ecs[0].arn
}

#########################
# Lambda Function Config
#########################

data "aws_iam_policy_document" "lambda" {
  count = local.create_role && var.attach_lambda_policy ? 1 : 0

  statement {
    sid       = "LambdaAccess"
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = var.lambda_target_arns
  }
}

resource "aws_iam_policy" "lambda" {
  count = local.create_role && var.attach_lambda_policy ? 1 : 0

  name   = "${local.role_name}-lambda"
  policy = data.aws_iam_policy_document.lambda[0].json

  tags = merge({ Name = "${local.role_name}-lambda" }, var.tags)
}

resource "aws_iam_policy_attachment" "lambda" {
  count = local.create_role && var.attach_lambda_policy ? 1 : 0

  name       = "${local.role_name}-lambda"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.lambda[0].arn
}

######################
# StepFunction Config
######################

data "aws_iam_policy_document" "sfn" {
  count = local.create_role && var.attach_sfn_policy ? 1 : 0

  statement {
    sid       = "StepFunctionAccess"
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = var.sfn_target_arns
  }
}

resource "aws_iam_policy" "sfn" {
  count = local.create_role && var.attach_sfn_policy ? 1 : 0

  name   = "${local.role_name}-sfn"
  policy = data.aws_iam_policy_document.sfn[0].json

  tags = merge({ Name = "${local.role_name}-sfn" }, var.tags)
}

resource "aws_iam_policy_attachment" "sfn" {
  count = local.create_role && var.attach_sfn_policy ? 1 : 0

  name       = "${local.role_name}-sfn"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.sfn[0].arn
}

#########################
# API Destination Config
#########################

data "aws_iam_policy_document" "api_destination" {
  count = local.create_role && var.attach_api_destination_policy ? 1 : 0

  statement {
    sid       = "APIDestinationAccess"
    effect    = "Allow"
    actions   = ["events:InvokeApiDestination"]
    resources = [for k, v in aws_cloudwatch_event_api_destination.this : v.arn]
  }
}

resource "aws_iam_policy" "api_destination" {
  count = local.create_role && var.attach_api_destination_policy ? 1 : 0

  name   = "${local.role_name}-api-destination"
  policy = data.aws_iam_policy_document.api_destination[0].json

  tags = merge({ Name = "${local.role_name}-api-destination" }, var.tags)
}

resource "aws_iam_policy_attachment" "api_destination" {
  count = local.create_role && var.attach_api_destination_policy ? 1 : 0

  name       = "${local.role_name}-api-destination"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.api_destination[0].arn
}

####################
# Cloudwatch Config
####################

data "aws_iam_policy_document" "cloudwatch" {
  count = local.create_role && var.attach_cloudwatch_policy ? 1 : 0

  statement {
    sid    = "CloudwatchAccess"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = var.cloudwatch_target_arns
  }
}

resource "aws_iam_policy" "cloudwatch" {
  count = local.create_role && var.attach_cloudwatch_policy ? 1 : 0

  name   = "${local.role_name}-cloudwatch"
  policy = data.aws_iam_policy_document.cloudwatch[0].json

  tags = merge({ Name = "${local.role_name}-cloudwatch" }, var.tags)
}

resource "aws_iam_policy_attachment" "cloudwatch" {
  count = local.create_role && var.attach_cloudwatch_policy ? 1 : 0

  name       = "${local.role_name}-cloudwatch"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.cloudwatch[0].arn
}

###########################
# Additional policy (JSON)
###########################

resource "aws_iam_policy" "additional_json" {
  count = local.create_role && var.attach_policy_json ? 1 : 0

  name   = local.role_name
  path   = var.role_path
  policy = var.policy_json

  tags = merge({ Name = local.role_name }, var.tags)
}

resource "aws_iam_policy_attachment" "additional_json" {
  count = local.create_role && var.attach_policy_json ? 1 : 0

  name       = local.role_name
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.additional_json[0].arn
}

#####################################
# Additional policies (list of JSON)
#####################################

resource "aws_iam_policy" "additional_jsons" {
  count = local.create_role && var.attach_policy_jsons ? var.number_of_policy_jsons : 0

  name   = "${local.role_name}-${count.index}"
  policy = var.policy_jsons[count.index]

  tags = merge({ Name = "${local.role_name}-${count.index}" }, var.tags)
}

resource "aws_iam_policy_attachment" "additional_jsons" {
  count = local.create_role && var.attach_policy_jsons ? var.number_of_policy_jsons : 0

  name       = "${local.role_name}-${count.index}"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.additional_jsons[count.index].arn
}

###########################
# ARN of additional policy
###########################

resource "aws_iam_role_policy_attachment" "additional_one" {
  count = local.create_role && var.attach_policy ? 1 : 0

  role       = aws_iam_role.eventbridge[0].name
  policy_arn = var.policy
}

######################################
# List of ARNs of additional policies
######################################

resource "aws_iam_role_policy_attachment" "additional_many" {
  count = local.create_role && var.attach_policies ? var.number_of_policies : 0

  role       = aws_iam_role.eventbridge[0].name
  policy_arn = var.policies[count.index]
}

###############################
# Additional policy statements
###############################

data "aws_iam_policy_document" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid           = lookup(statement.value, "sid", replace(statement.key, "/[^0-9A-Za-z]*/", ""))
      effect        = lookup(statement.value, "effect", null)
      actions       = lookup(statement.value, "actions", null)
      not_actions   = lookup(statement.value, "not_actions", null)
      resources     = lookup(statement.value, "resources", null)
      not_resources = lookup(statement.value, "not_resources", null)

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = lookup(statement.value, "not_principals", [])
        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "condition", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  name   = "${local.role_name}-inline"
  policy = data.aws_iam_policy_document.additional_inline[0].json

  tags = merge({ Name = "${local.role_name}-inline" }, var.tags)
}

resource "aws_iam_policy_attachment" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  name       = local.role_name
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.additional_inline[0].arn
}
