# EventBridge Input Transform Example

Configuration in this directory creates EventBridge resource configuration.

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.19 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.19 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | ../../ |  |

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_iam_policy_document.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_bus_arn"></a> [eventbridge\_bus\_arn](#output\_eventbridge\_bus\_arn) | The EventBridge Bus ARN |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
