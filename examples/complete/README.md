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
