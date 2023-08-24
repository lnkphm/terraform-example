terraform {
  backend "s3" {
    bucket = "lnkphm-terraform-state"
    key    = "terraform-example/stage/storages/mysql/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "lnkphm-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "mysql" {
  source = "github.com/lnkphm/terraform-modules-example//storages/mysql?ref=v0.0.1"

  db_name = "example-stage-database"
  db_username = "admin"
  db_password = "qwerty1!"
}
