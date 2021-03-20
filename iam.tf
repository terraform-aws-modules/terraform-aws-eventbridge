locals {
  create_role = var.create && var.create_bus
  role_name   = local.create_role ? coalesce(var.role_name, var.bus_name, "*") : null
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
      identifiers = ["cloudwatch.amazonaws.com", "events.amazonaws.com"]
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

  tags = merge(var.tags, var.role_tags)
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
    sid       = "SQSAccess"
    effect    = "Allow"
    actions   = ["sqs:sendMessage"]
    resources = var.sqs_target_arns
  }
}

resource "aws_iam_policy" "sqs" {
  count = local.create_role && var.attach_sqs_policy ? 1 : 0

  name   = "${local.role_name}-sqs"
  policy = data.aws_iam_policy_document.sqs[0].json
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
    resources = var.ecs_target_arns
  }
}

resource "aws_iam_policy" "ecs" {
  count = local.create_role && var.attach_ecs_policy ? 1 : 0

  name   = "${local.role_name}-ecs"
  policy = data.aws_iam_policy_document.ecs[0].json
}

resource "aws_iam_policy_attachment" "ecs" {
  count = local.create_role && var.attach_ecs_policy ? 1 : 0

  name       = "${local.role_name}-ecs"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.ecs[0].arn
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
}

resource "aws_iam_policy_attachment" "sfn" {
  count = local.create_role && var.attach_sfn_policy ? 1 : 0

  name       = "${local.role_name}-sfn"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.sfn[0].arn
}
