# EventBridge Permission Example

Configuration in this directory creates resources to control access to EventBridge.

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
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_bus.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_bus_arn"></a> [eventbridge\_bus\_arn](#output\_eventbridge\_bus\_arn) | The EventBridge Bus ARN |
| <a name="output_eventbridge_permission_ids"></a> [eventbridge\_permission\_ids](#output\_eventbridge\_permission\_ids) | The EventBridge Permissions |
<!-- END_TF_DOCS -->
