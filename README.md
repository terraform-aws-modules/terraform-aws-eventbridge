# AWS EventBridge Terraform module

Terraform module to create EventBridge resources.

The following resources are currently supported:

* [Cloudwatch Event Archive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_archive)
* [Cloudwatch Event Bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus)
* [Cloudwatch Event Permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_permission)
* [Cloudwatch Event Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)
* [Cloudwatch Event Target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target)

## Features

- [x] Creates AWS EventBridge Resources
- [x] Support AWS EventBridge Archives and Replays
- [x] Conditional creation for many types of resources
- [x] Support IAM policy attachments and various ways to create and attach additional policies
- [ ] Support monitoring usage with Cloudwatch Metrics

## Usage

### EventBridge Bus

```hcl
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "my-bus"

  tags = {
    Name = "my-bus"
  }
}
```

### EventBridge Rule 

```hcl
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "my-bus"

  create_targets = false
  
  rules = {
    logs = {
      description   = "Capture log data"
      event_pattern = jsonencode({ "source" : ["my.app.logs"] })
    }
  }

  tags = {
    Name = "my-bus"
  }
}
```

### EventBridge Target

```hcl
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "my-bus"
  
  rules = {
    logs = {
      description   = "Capture log data"
      event_pattern = jsonencode({ "source" : ["my.app.logs"] })
    }
  }
  
  targets = {
    logs = [
      {
        name = "send-logs-to-sqs"
        arn  = aws_sqs_queue.queue.arn
      },
      {
        name = "send-logs-to-cloudwatch"
        arn  = aws_cloudwatch_log_stream.logs.arn
      }
    ]
  }

  tags = {
    Name = "my-bus"
  }
}
```

### EventBridge Archive

```hcl
module "eventbridge_with_archive" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "my-bus"
  
  create_archives = true

  archive_config = [
    {
      name           = "my-bus-launch-archive",
      description    = "EC2 AutoScaling Event archive",
      retention_days = 1
      event_pattern  = <<PATTERN
      {
        "source": ["aws.autoscaling"],
        "detail-type": ["EC2 Instance Launch Successful"]
      }
      PATTERN
    }
  ]

  tags = {
    Name = "my-bus"
  }
}
```

### EventBridge Permission 

```hcl
module "eventbridge_with_permissions" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "my-bus"

  create_permissions = true

  permission_config = [
    {
      account_id   = "YOUR_ACCOUNT_ID",
      statement_id = "development_account"
    }
  ]

  tags = {
    Name = "my-bus"
  }
}
```

## Additional IAM policies for Step Function

In addition to all supported AWS service integrations you may want to create and attach additional policies.

There are 5 supported ways to attach additional IAM policies to IAM role used by Step Function:

  1. `policy_json` - JSON string or heredoc, when `attach_policy_json = true`.
  2. `policy_jsons` - List of JSON strings or heredoc, when `attach_policy_jsons = true` and `number_of_policy_jsons > 0`.
  3. `policy` - ARN of existing IAM policy, when `attach_policy = true`.
  4. `policies` - List of ARNs of existing IAM policies, when `attach_policies = true` and `number_of_policies > 0`.
  5. `policy_statements` - Map of maps to define IAM statements which will be generated as IAM policy. Requires `attach_policy_statements = true`. See `examples/complete` for more information.

## Conditional creation

Sometimes you need to have a way to create resources conditionally but Terraform does not allow usage of `count` inside `module` block, so the solution is to specify `create` arguments.

```hcl
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create = false # to disable all resources

  create_bus         = false  # to control creation of the EventBridge Bus and related resources
  create_rule        = false  # to control creation of EventBridge Rules and related resources
  create_targets     = false  # to control creation of EventBridge Targets and related resources
  create_archives    = false  # to control creation of EventBridge Archives
  create_permissions = false  # to control creation of EventBridge Permissions
  create_role        = false  # to control creation of the IAM role and policies required for EventBridge

  attach_kinesis_policy          = false
  attach_kinesis_firehose_policy = false
  attach_sqs_policy              = false
  attach_ecs_policy              = false
  attach_lambda_policy           = false
  attach_sfn_policy              = false
  attach_cloudwatch_policy       = false
  attach_tracing_policy          = false

  # ... omitted
}
```

## Examples

* [Complete](/examples/complete)
* [Simple](/examples/simple)
* [Archive](/examples/with-archive)
* [Permissions](/examples/with-permissions)
* [SQS Target](/examples/sqs-target)
* [API-Gateway](/examples/api-gateway-event-source)
* [Input Transformation](/examples/transform-input)
* [Step Function Target](/examples/step-function-target)

## Change log

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 3.19 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.19 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_cloudwatch_event_archive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_archive) |
| [aws_cloudwatch_event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) |
| [aws_cloudwatch_event_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_permission) |
| [aws_cloudwatch_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) |
| [aws_cloudwatch_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| archive\_config | A list of objects with the EventBridge Archive definitions. | `list(any)` | `[]` | no |
| attach\_cloudwatch\_policy | Controls whether the Cloudwatch policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_ecs\_policy | Controls whether the ECS policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_kinesis\_firehose\_policy | Controls whether the Kinesis Firehose policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_kinesis\_policy | Controls whether the Kinesis policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_lambda\_policy | Controls whether the Lambda Function policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_policies | Controls whether list of policies should be added to IAM role | `bool` | `false` | no |
| attach\_policy | Controls whether policy should be added to IAM role | `bool` | `false` | no |
| attach\_policy\_json | Controls whether policy\_json should be added to IAM role | `bool` | `false` | no |
| attach\_policy\_jsons | Controls whether policy\_jsons should be added to IAM role | `bool` | `false` | no |
| attach\_policy\_statements | Controls whether policy\_statements should be added to IAM role | `bool` | `false` | no |
| attach\_sfn\_policy | Controls whether the StepFunction policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_sqs\_policy | Controls whether the SQS policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_tracing\_policy | Controls whether X-Ray tracing policy should be added to IAM role for EventBridge | `bool` | `false` | no |
| bus\_name | A unique name for your EventBridge Bus | `string` | `""` | no |
| cloudwatch\_target\_arns | The Amazon Resource Name (ARN) of the Cloudwatch Log Streams you want to use as EventBridge targets | `list(string)` | `[]` | no |
| create | Controls whether resources should be created | `bool` | `true` | no |
| create\_archives | Controls whether EventBridge Archive resources should be created | `bool` | `false` | no |
| create\_bus | Controls whether EventBridge Bus resource should be created | `bool` | `true` | no |
| create\_permissions | Controls whether EventBridge Permission resources should be created | `bool` | `true` | no |
| create\_role | Controls whether IAM role for Lambda Function should be created | `bool` | `true` | no |
| create\_rules | Controls whether EventBridge Rule resources should be created | `bool` | `true` | no |
| create\_targets | Controls whether EventBridge Target resources should be created | `bool` | `true` | no |
| ecs\_target\_arns | The Amazon Resource Name (ARN) of the AWS ECS Tasks you want to use as EventBridge targets | `list(string)` | `[]` | no |
| kinesis\_firehose\_target\_arns | The Amazon Resource Name (ARN) of the Kinesis Firehose Delivery Streams you want to use as EventBridge targets | `list(string)` | `[]` | no |
| kinesis\_target\_arns | The Amazon Resource Name (ARN) of the Kinesis Streams you want to use as EventBridge targets | `list(string)` | `[]` | no |
| lambda\_target\_arns | The Amazon Resource Name (ARN) of the Lambda Functions you want to use as EventBridge targets | `list(string)` | `[]` | no |
| number\_of\_policies | Number of policies to attach to IAM role | `number` | `0` | no |
| number\_of\_policy\_jsons | Number of policies JSON to attach to IAM role | `number` | `0` | no |
| permission\_config | A list of objects with EventBridge Permission definitions. | `list(any)` | `[]` | no |
| policies | List of policy statements ARN to attach to IAM role | `list(string)` | `[]` | no |
| policy | An additional policy document ARN to attach to IAM role | `string` | `null` | no |
| policy\_json | An additional policy document as JSON to attach to IAM role | `string` | `null` | no |
| policy\_jsons | List of additional policy documents as JSON to attach to IAM role | `list(string)` | `[]` | no |
| policy\_statements | Map of dynamic policy statements to attach to IAM role | `any` | `{}` | no |
| role\_description | Description of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_force\_detach\_policies | Specifies to force detaching any policies the IAM role has before destroying it. | `bool` | `true` | no |
| role\_name | Name of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_path | Path of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_permissions\_boundary | The ARN of the policy that is used to set the permissions boundary for the IAM role used by Lambda Function | `string` | `null` | no |
| role\_tags | A map of tags to assign to IAM role | `map(string)` | `{}` | no |
| rules | A map of objects with EventBridge Rule definitions. | `map(any)` | `{}` | no |
| sfn\_target\_arns | The Amazon Resource Name (ARN) of the StepFunctions you want to use as EventBridge targets | `list(string)` | `[]` | no |
| sqs\_target\_arns | The Amazon Resource Name (ARN) of the AWS SQS Queues you want to use as EventBridge targets | `list(string)` | `[]` | no |
| tags | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| targets | A Map of objects with EventBridge Target definitions. | `any` | `{}` | no |
| trusted\_entities | Step Function additional trusted entities for assuming roles (trust relationship) | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| eventbridge\_role\_arn | The ARN of the IAM role created for EventBridge |
| eventbridge\_role\_name | The name of the IAM role created for EventBridge |
| this\_eventbridge\_archive\_arns | The EventBridge Archive Arns created |
| this\_eventbridge\_bus\_arn | The EventBridge Bus Arn |
| this\_eventbridge\_bus\_name | The EventBridge Bus Name |
| this\_eventbridge\_permission\_ids | The EventBridge Permission Arns created |
| this\_eventbridge\_rule\_arns | The EventBridge Rule ARNs created |
| this\_eventbridge\_rule\_ids | The EventBridge Rule IDs created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sven Lito](https://github.com/svenlito). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

## License

Apache 2 Licensed. See LICENSE for full details.
