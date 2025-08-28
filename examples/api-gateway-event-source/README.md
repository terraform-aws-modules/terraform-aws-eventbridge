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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.6 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.6 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | terraform-aws-modules/apigateway-v2/aws | ~> 4.0 |
| <a name="module_apigateway_put_events_to_eventbridge_policy"></a> [apigateway\_put\_events\_to\_eventbridge\_policy](#module\_apigateway\_put\_events\_to\_eventbridge\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | ~> 4.0 |
| <a name="module_apigateway_put_events_to_eventbridge_role"></a> [apigateway\_put\_events\_to\_eventbridge\_role](#module\_apigateway\_put\_events\_to\_eventbridge\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | ~> 4.0 |
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_iam_policy_document.apigateway_put_events_to_eventbridge_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_bus_arn"></a> [eventbridge\_bus\_arn](#output\_eventbridge\_bus\_arn) | The EventBridge Bus Arn |
| <a name="output_eventbridge_bus_name"></a> [eventbridge\_bus\_name](#output\_eventbridge\_bus\_name) | The EventBridge Bus Name |
| <a name="output_eventbridge_role_arn"></a> [eventbridge\_role\_arn](#output\_eventbridge\_role\_arn) | The ARN of the IAM role created for EventBridge |
| <a name="output_eventbridge_role_name"></a> [eventbridge\_role\_name](#output\_eventbridge\_role\_name) | The name of the IAM role created for EventBridge |
| <a name="output_eventbridge_rule_arns"></a> [eventbridge\_rule\_arns](#output\_eventbridge\_rule\_arns) | The EventBridge Rule ARNs created |
| <a name="output_eventbridge_rule_ids"></a> [eventbridge\_rule\_ids](#output\_eventbridge\_rule\_ids) | The EventBridge Rule IDs created |
<!-- END_TF_DOCS -->
