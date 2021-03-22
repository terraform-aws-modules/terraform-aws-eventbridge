# EventBridge Permission Example

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
| terraform | >= 0.14.0 |
| aws | >= 3.19 |
| random | >= 0 |

## Providers

| Name | Version |
|------|---------|
| random | >= 0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| eventbridge | ../../ |  |

## Resources

| Name |
|------|
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| eventbridge\_bus\_arn | The EventBridge Bus ARN |
| this\_eventbridge\_permission\_ids | The EventBridge Permissions |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
