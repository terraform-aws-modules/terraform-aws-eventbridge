# AWS EventBridge Terraform module

Terraform module to create EventBridge resources.

This type of resources supported:

* [Cloudwatch_Event_Archive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_archive)
* [Cloudwatch_Event_Bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus)
* [Cloudwatch_Event_Permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_permission)
* [Cloudwatch_Event_Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)
* [Cloudwatch_Event_Target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target)

## Terraform versions

Terraform 0.12 or newer is supported.

## Usage

### EventBridge Bus

```hcl
module "eventbridge" {
  source = ""

  bus_name = "my-bus"

  tags = {
    Name = "my-bus"
  }
}
```

### EventBridge Archive

```hcl
module "eventbridge_with_archive" {
  source = ""

  bus_name = "my-bus"
  
  create_archives = true

  archive_configs = [
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
  source = ""

  bus_name = "my-bus"

  create_permissions = true

  permissions = [
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

## Examples

* [Complete](/examples/complete)
* [Simple](/examples/simple)
* [Archive](/examples/with-archive)
* [Permissions](/examples/with-permissions)
* [SQS Target](/examples/sqs-target)
* [API-Gateway](/examples/api-gateway)

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| archive\_configs | A list of objects with the EventBridge Archive definitions. | `list(any)` | `[]` | no |
| attach\_cloudwatch\_policy | Controls whether the Cloudwatch policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_ecs\_policy | Controls whether the ECS policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_kinesis\_firehose\_policy | Controls whether the Kinesis Firehose policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_kinesis\_policy | Controls whether the Kinesis policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_lambda\_policy | Controls whether the Lambda Function policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
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
| permissions | A list of objects with EventBridge Permission definitions. | `list(any)` | `[]` | no |
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

## License

Apache 2 Licensed. See LICENSE for full details.
