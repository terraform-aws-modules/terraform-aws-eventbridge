# EventBridge Default Bus Example

Configuration in this directory creates EventBridge resource configuration using `default` EventBridge bus.

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
| [aws_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| eventbridge\_bus\_arn | The EventBridge Bus ARN |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

