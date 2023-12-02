# EventBridge Pipes Example

Configuration in this directory creates EventBridge Pipes in multiple configurations.

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.27 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.27 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | ../../ | n/a |
| <a name="module_lambda_target"></a> [lambda\_target](#module\_lambda\_target) | terraform-aws-modules/lambda/aws | ~> 6.0 |
| <a name="module_step_function_target"></a> [step\_function\_target](#module\_step\_function\_target) | terraform-aws-modules/step-functions/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_api_destination.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_api_destination) | resource |
| [aws_cloudwatch_event_bus.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) | resource |
| [aws_cloudwatch_event_connection.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_connection) | resource |
| [aws_cloudwatch_log_group.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_dynamodb_table.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_role.eventbridge_pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kinesis_stream.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_iam_policy_document.assume_role_pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_pipe_arns"></a> [eventbridge\_pipe\_arns](#output\_eventbridge\_pipe\_arns) | The EventBridge Pipes ARNs |
| <a name="output_eventbridge_pipe_ids"></a> [eventbridge\_pipe\_ids](#output\_eventbridge\_pipe\_ids) | The EventBridge Pipes IDs |
| <a name="output_eventbridge_pipe_role_arns"></a> [eventbridge\_pipe\_role\_arns](#output\_eventbridge\_pipe\_role\_arns) | The ARNs of the IAM role created for EventBridge Pipes |
| <a name="output_eventbridge_pipe_role_names"></a> [eventbridge\_pipe\_role\_names](#output\_eventbridge\_pipe\_role\_names) | The names of the IAM role created for EventBridge Pipes |
| <a name="output_eventbridge_pipes"></a> [eventbridge\_pipes](#output\_eventbridge\_pipes) | The EventBridge Pipes created and their attributes |
| <a name="output_eventbridge_pipes_iam_roles"></a> [eventbridge\_pipes\_iam\_roles](#output\_eventbridge\_pipes\_iam\_roles) | The EventBridge Pipes IAM roles created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
