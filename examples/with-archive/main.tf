provider "aws" {
  region = "ap-southeast-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

resource "random_pet" "this" {
  length = 2
}

module "eventbridge" {
  source = "../../"

  create_archive = true

  archive_config = {
    description    = "${random_pet.this.id}-archive",
    retention_days = 1
    event_pattern  = <<PATTERN
    {
      "source": ["co.twitter"]
    }
    PATTERN
  }

  bus_name = "${random_pet.this.id}-bus"

  tags = {
    Name = "${random_pet.this.id}-bus"
  }
}

