provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

module "eventbridge" {
  source = "../../"

  create_bus = false

  rules = {
    product_create = {
      description   = "product create rule",
      event_pattern = jsonencode({ "source" : ["product.create"] })
    }
  }

  targets = {
    product_create = [
      {
        arn  = aws_sqs_queue.products.arn
        name = "send-product-to-sqs"
      }
    ]
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_sqs_queue" "products" {
  name = random_pet.this.id
}
