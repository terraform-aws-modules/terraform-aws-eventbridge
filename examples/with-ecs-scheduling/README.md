# EventBridge ECS & Scheduled Events Example

Configuration in this directory creates EventBridge resource configuration including an ECS service.

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
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.27 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws | ~> 5.0 |
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_bus_arn"></a> [eventbridge\_bus\_arn](#output\_eventbridge\_bus\_arn) | The EventBridge Bus ARN |
| <a name="output_eventbridge_rule_arns"></a> [eventbridge\_rule\_arns](#output\_eventbridge\_rule\_arns) | The EventBridge Rule ARNs |
| <a name="output_eventbridge_rule_ids"></a> [eventbridge\_rule\_ids](#output\_eventbridge\_rule\_ids) | The EventBridge Rule IDs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
