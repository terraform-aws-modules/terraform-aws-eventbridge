# EventBridge Archive Example

Configuration in this directory creates EventBridge Archives resources in various configurations.

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
| eventbridge_archive_only | ../../ |  |

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
| eventbridge\_archive\_arns | The EventBridge Archive ARNs |
| eventbridge\_bus\_arn | The EventBridge Bus ARN |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
