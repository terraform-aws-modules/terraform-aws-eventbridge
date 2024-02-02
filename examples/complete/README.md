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
| <a name="module_bucket"></a> [bucket](#module\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |
| <a name="module_disabled"></a> [disabled](#module\_disabled) | ../../ | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | terraform-aws-modules/ecs/aws | ~> 3.0 |
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | ../../ | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 6.0 |
| <a name="module_sns"></a> [sns](#module\_sns) | terraform-aws-modules/sns/aws | ~> 6.0 |
| <a name="module_step_function"></a> [step\_function](#module\_step\_function) | terraform-aws-modules/step-functions/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.hello_world](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.hello_world](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_kinesis_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.fifo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_api_destinations"></a> [eventbridge\_api\_destinations](#output\_eventbridge\_api\_destinations) | The EventBridge API Destinations created and their attributes |
| <a name="output_eventbridge_archives"></a> [eventbridge\_archives](#output\_eventbridge\_archives) | The EventBridge Archives created and their attributes |
| <a name="output_eventbridge_bus"></a> [eventbridge\_bus](#output\_eventbridge\_bus) | The EventBridge Bus created and their attributes |
| <a name="output_eventbridge_bus_arn"></a> [eventbridge\_bus\_arn](#output\_eventbridge\_bus\_arn) | The EventBridge Bus ARN |
| <a name="output_eventbridge_connections"></a> [eventbridge\_connections](#output\_eventbridge\_connections) | The EventBridge Connections created and their attributes |
| <a name="output_eventbridge_iam_roles"></a> [eventbridge\_iam\_roles](#output\_eventbridge\_iam\_roles) | The EventBridge IAM roles created and their attributes |
| <a name="output_eventbridge_permissions"></a> [eventbridge\_permissions](#output\_eventbridge\_permissions) | The EventBridge Permissions created and their attributes |
| <a name="output_eventbridge_pipes"></a> [eventbridge\_pipes](#output\_eventbridge\_pipes) | The EventBridge Pipes created and their attributes |
| <a name="output_eventbridge_pipes_iam_roles"></a> [eventbridge\_pipes\_iam\_roles](#output\_eventbridge\_pipes\_iam\_roles) | The EventBridge Pipes IAM roles created and their attributes |
| <a name="output_eventbridge_rule_arns"></a> [eventbridge\_rule\_arns](#output\_eventbridge\_rule\_arns) | The EventBridge Rule ARNs |
| <a name="output_eventbridge_rule_ids"></a> [eventbridge\_rule\_ids](#output\_eventbridge\_rule\_ids) | The EventBridge Rule IDs |
| <a name="output_eventbridge_rules"></a> [eventbridge\_rules](#output\_eventbridge\_rules) | The EventBridge Rules created and their attributes |
| <a name="output_eventbridge_schedule_groups"></a> [eventbridge\_schedule\_groups](#output\_eventbridge\_schedule\_groups) | The EventBridge Schedule Groups created and their attributes |
| <a name="output_eventbridge_schedules"></a> [eventbridge\_schedules](#output\_eventbridge\_schedules) | The EventBridge Schedules created and their attributes |
| <a name="output_eventbridge_targets"></a> [eventbridge\_targets](#output\_eventbridge\_targets) | The EventBridge Targets created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
