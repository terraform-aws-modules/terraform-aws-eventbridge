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

```hcl
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

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

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
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| archive\_config | n/a | `map(any)` | `{}` | no |
| attach\_ecs\_policy | Controls whether the ECS policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_kinesis\_firehose\_policy | Controls whether the Kinesis Firehose policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_kinesis\_policy | Controls whether the Kinesis policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_sfn\_policy | Controls whether the StepFunction policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| attach\_sqs\_policy | Controls whether the SQS policy should be added to IAM role for EventBridge Target | `bool` | `false` | no |
| bus\_name | n/a | `string` | `""` | no |
| create | n/a | `bool` | `true` | no |
| create\_archive | n/a | `bool` | `false` | no |
| create\_bus | n/a | `bool` | `true` | no |
| create\_permissions | n/a | `bool` | `true` | no |
| create\_targets | n/a | `bool` | `true` | no |
| ecs\_target\_arns | n/a | `list(string)` | `[]` | no |
| kinesis\_firehose\_target\_arns | n/a | `list(string)` | `[]` | no |
| kinesis\_target\_arns | n/a | `list(string)` | `[]` | no |
| permissions | A list of objects with the permission definitions. | `list(any)` | `[]` | no |
| role\_description | Description of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_force\_detach\_policies | Specifies to force detaching any policies the IAM role has before destroying it. | `bool` | `true` | no |
| role\_name | Name of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_path | Path of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_permissions\_boundary | The ARN of the policy that is used to set the permissions boundary for the IAM role used by Lambda Function | `string` | `null` | no |
| role\_tags | A map of tags to assign to IAM role | `map(string)` | `{}` | no |
| rules | A map of objects with the rules definitions. | `map(any)` | `{}` | no |
| sfn\_target\_arns | n/a | `list(string)` | `[]` | no |
| sqs\_target\_arns | n/a | `list(string)` | `[]` | no |
| tags | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| targets | A Map of objects with the target definitions. | `any` | `{}` | no |
| trusted\_entities | Lambda Function additional trusted entities for assuming roles (trust relationship) | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_eventbridge\_bus\_arn | The EventBridge Bus Arn |
| this\_eventbridge\_rule\_arns | ARNs |
| this\_eventbridge\_rule\_ids | IDs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

## License

Apache 2 Licensed. See LICENSE for full details.
