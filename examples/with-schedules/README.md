# EventBridge Scheduler with Schedule Groups Example

Configuration in this directory creates EventBridge Scheduler resources which triggers Lambda Function.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.6 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.6 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | ../../ | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 8.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kinesis_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_schedule_arns"></a> [eventbridge\_schedule\_arns](#output\_eventbridge\_schedule\_arns) | The EventBridge Schedule ARNs created |
| <a name="output_eventbridge_schedule_group_arns"></a> [eventbridge\_schedule\_group\_arns](#output\_eventbridge\_schedule\_group\_arns) | The EventBridge Schedule Group ARNs |
| <a name="output_eventbridge_schedule_group_ids"></a> [eventbridge\_schedule\_group\_ids](#output\_eventbridge\_schedule\_group\_ids) | The EventBridge Schedule Group IDs |
| <a name="output_eventbridge_schedule_group_states"></a> [eventbridge\_schedule\_group\_states](#output\_eventbridge\_schedule\_group\_states) | The EventBridge Schedule Group states |
| <a name="output_eventbridge_schedule_ids"></a> [eventbridge\_schedule\_ids](#output\_eventbridge\_schedule\_ids) | The EventBridge Schedule IDs created |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the Lambda Function |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda Function |
<!-- END_TF_DOCS -->
