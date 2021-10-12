# EventBridge ECS & Scheduled Events Example

Configuration in this directory creates EventBridge resource configuration including an ECS service.

This requires you to have setup an ECS cluster and VPC and passed them in via variables.

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.19 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.47.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs"></a> [ecs](#module\_ecs) | terraform-aws-modules/ecs/aws | ~> 3.0 |
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.hello_world](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.hello_world](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster) | An ECS cluster ARN to launch tasks in. | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | public subnets the task should run in. | `list(string)` | n/a | yes |
| <a name="input_vpc_security_groups"></a> [vpc\_security\_groups](#input\_vpc\_security\_groups) | vpc security groups the task should run in. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_bus_arn"></a> [eventbridge\_bus\_arn](#output\_eventbridge\_bus\_arn) | The EventBridge Bus ARN |
| <a name="output_eventbridge_rule_arns"></a> [eventbridge\_rule\_arns](#output\_eventbridge\_rule\_arns) | The EventBridge Rule ARNs |
| <a name="output_eventbridge_rule_ids"></a> [eventbridge\_rule\_ids](#output\_eventbridge\_rule\_ids) | The EventBridge Rule IDs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->