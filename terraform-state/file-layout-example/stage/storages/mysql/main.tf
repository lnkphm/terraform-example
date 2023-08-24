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

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-example"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
}

