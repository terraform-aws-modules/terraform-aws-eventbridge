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

* [Complete_example](https://github.com/)

## Change log

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| archive\_config | n/a | `map(any)` | `{}` | no |
| attach\_kinesis\_policy | n/a | `bool` | `true` | no |
| attach\_sqs\_policy | n/a | `bool` | `true` | no |
| bus\_name | n/a | `string` | `""` | no |
| cloudwatch\_logging\_enabled | n/a | `bool` | `true` | no |
| cloudwatch\_retention\_days | n/a | `number` | `7` | no |
| create | n/a | `bool` | `true` | no |
| create\_archive | n/a | `bool` | `false` | no |
| create\_bus | n/a | `bool` | `true` | no |
| create\_permissions | n/a | `bool` | `true` | no |
| environment | n/a | `string` | `""` | no |
| kinesis\_target\_arn | n/a | `string` | `""` | no |
| permissions | A list of objects with the permission definitions. | `list(any)` | `[]` | no |
| role\_description | Description of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_force\_detach\_policies | Specifies to force detaching any policies the IAM role has before destroying it. | `bool` | `true` | no |
| role\_name | Name of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_path | Path of IAM role to use for Lambda Function | `string` | `null` | no |
| role\_permissions\_boundary | The ARN of the policy that is used to set the permissions boundary for the IAM role used by Lambda Function | `string` | `null` | no |
| role\_tags | A map of tags to assign to IAM role | `map(string)` | `{}` | no |
| rules | A map of objects with the rules definitions. | `map(any)` | `{}` | no |
| sqs\_target\_arn | n/a | `string` | `""` | no |
| stage | n/a | `string` | `""` | no |
| tags | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| targets | A Map of objects with the target definitions. | `any` | `{}` | no |
| trusted\_entities | Lambda Function additional trusted entities for assuming roles (trust relationship) | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_eventbridge\_rule\_arns | ARNs |
| this\_eventbridge\_rule\_ids | IDs |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

## License

Apache 2 Licensed. See LICENSE for full details.
