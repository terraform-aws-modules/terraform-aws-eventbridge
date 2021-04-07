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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.1 |
| aws | >= 3.19 |
| random | >= 3 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.19 |
| random | >= 3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| eventbridge | ../../ |  |

## Resources

| Name |
|------|
| [aws_cloudwatch_event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| eventbridge\_bus\_arn | The EventBridge Bus ARN |
| this\_eventbridge\_permission\_ids | The EventBridge Permissions |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
