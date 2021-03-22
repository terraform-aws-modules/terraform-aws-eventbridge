# EventBridge Complete Example

Configuration in this directory creates EventBridge resource configuration including an SQS queue, Kinesis stream, and DynamoDB table.

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
| eventbridge | ../../ |  |

## Resources

| Name |
|------|
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_kinesis_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) |
| [aws_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) |
| [aws_sqs_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| eventbridge\_bus\_arn | The EventBridge Bus ARN |
| eventbridge\_rule\_arns | The EventBridge Rule ARNs |
| eventbridge\_rule\_ids | The EventBridge Rule IDs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
