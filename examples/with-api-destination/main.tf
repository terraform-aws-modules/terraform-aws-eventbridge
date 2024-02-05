provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

module "eventbridge" {
  source = "../../"

  create_bus              = true
  create_connections      = true
  create_api_destinations = true

  bus_name = "${random_pet.this.id}-bus"

  attach_api_destination_policy = true

  rules = {
    orders = {
      description   = "Capture all order data"
      event_pattern = jsonencode({ "source" : ["myapp.orders"] })
      state         = "ENABLED" # conflicts with enabled which is deprecated
    }
    refunds = {
      description   = "Capture all refund data"
      event_pattern = jsonencode({ "source" : ["myapp.refunds"] })
      state         = "ENABLED" # conflicts with enabled which is deprecated
    }
  }

  targets = {
    orders = [
      {
        name            = "send-orders-to-requestbin"
        destination     = "requestbin"
        attach_role_arn = aws_iam_role.eventbridge.arn
      },
      {
        name            = "send-orders-to-github"
        destination     = "github"
        attach_role_arn = true
      }
    ]
    refunds = [
      {
        name            = "send-refunds-to-github"
        destination     = "refunds_github"
        attach_role_arn = true
      }
    ]
  }

  connections = {
    requestbin = {
      authorization_type = "BASIC"
      auth_parameters = {

        basic = {
          username = random_pet.this.id
          password = random_pet.this.id
        }

        invocation_http_parameters = {
          body = [{
            key             = "body-parameter-key"
            value           = "body-parameter-value"
            is_value_secret = false
            }, {
            key             = "body-secret-key"
            value           = "body-secret-value"
            is_value_secret = true
            }
          ]

          header = [{
            key             = "header-parameter-key1"
            value           = "header-parameter-value1"
            is_value_secret = false
            }, {
            key   = "header-parameter-key2"
            value = "header-parameter-value2"
          }]

          query_string = [{
            key             = "query-string-parameter-key1"
            value           = "query-string-parameter-value1"
            is_value_secret = false
            }, {
            key   = "query-string-parameter-key2"
            value = "query-string-parameter-value2"
          }]
        }
      }
    }

    smee = {
      authorization_type = "OAUTH_CLIENT_CREDENTIALS"
      auth_parameters = {
        oauth = {
          authorization_endpoint = "https://smee.io/hgoubgoibwekt331"
          http_method            = "GET"

          client_parameters = {
            client_id     = "1234567890"
            client_secret = "Pass1234!"
          }

          oauth_http_parameters = {
            body = [{
              key             = "body-parameter-key"
              value           = "body-parameter-value"
              is_value_secret = false
            }]

            header = [{
              key   = "header-parameter-key1"
              value = "header-parameter-value1"
              }, {
              key             = "header-parameter-key2"
              value           = "header-parameter-value2"
              is_value_secret = true
            }]

            query_string = [{
              key             = "query-string-parameter-key"
              value           = "query-string-parameter-value"
              is_value_secret = false
            }]
          }
        }
      }
    }

    github = {
      authorization_type = "API_KEY"
      auth_parameters = {
        api_key = {
          key   = "x-signature-id"
          value = random_pet.this.id
        }
      }
    }
  }

  api_destinations = {
    smee = {
      description                      = "my smee endpoint"
      invocation_endpoint              = "https://smee.io/hgoubgoibwekt331"
      http_method                      = "POST"
      invocation_rate_limit_per_second = 200
    }
    requestbin = {
      description                      = "my requestbin endpoint"
      invocation_endpoint              = "https://smee.io/hgoubGoIbWEKt331"
      http_method                      = "POST"
      invocation_rate_limit_per_second = 20
    }
    github = {
      description                      = "my github endpoint"
      invocation_endpoint              = "https://smee.io/hgoubGoIbWEKt331"
      http_method                      = "POST"
      invocation_rate_limit_per_second = 20
    }
    # reuse github connection
    refunds_github = {
      description                      = "my refunds to github endpoint"
      invocation_endpoint              = "https://smee.io/QaM356V2p1PFFZS"
      http_method                      = "POST"
      invocation_rate_limit_per_second = 20
      connection_name                  = "github"
    }
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_iam_role" "eventbridge" {
  name               = "${random_pet.this.id}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}
