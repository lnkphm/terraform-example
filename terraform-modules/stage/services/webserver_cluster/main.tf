terraform {
  backend "s3" {
    bucket = "lnkphm-terraform-state"
    key    = "terraform-example/stage/services/webserver-cluster/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "lnkphm-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "webserver_cluster" {
  source = "github.com/lnkphm/terraform-modules-example//services/webserver-cluster?ref=v0.0.1"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "lnkphm-terraform-state"
  db_remote_state_key    = "terraform-example/stage/storages/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
