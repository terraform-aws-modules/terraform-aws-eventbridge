# EventBridge API Gateway Event Source

Configuration in this directory creates EventBridge resource configuration including an API Gateway and a SQS queue.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| aws | >= 3.19 |
| random | >= 0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.19 |
| random | >= 0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| api_gateway | terraform-aws-modules/apigateway-v2/aws | 0.14.0 |
| apigateway_put_events_to_eventbridge_policy | terraform-aws-modules/iam/aws//modules/iam-policy | 3.13.0 |
| apigateway_put_events_to_eventbridge_role | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 3.13.0 |
| eventbridge | ../../ |  |

## Resources

| Name |
|------|
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) |
| [aws_sqs_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| eventbridge\_role\_arn | The ARN of the IAM role created for EventBridge |
| eventbridge\_role\_name | The name of the IAM role created for EventBridge |
| this\_eventbridge\_bus\_arn | The EventBridge Bus Arn |
| this\_eventbridge\_bus\_name | The EventBridge Bus Name |
| this\_eventbridge\_rule\_arns | The EventBridge Rule ARNs created |
| this\_eventbridge\_rule\_ids | The EventBridge Rule IDs created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
