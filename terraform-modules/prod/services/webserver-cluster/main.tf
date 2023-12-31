terraform {
  backend "s3" {
    bucket = "lnkphm-terraform-state"
    key    = "terraform-example/prod/services/webserver-cluster/terraform.tfstate"
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

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "lnkphm-terraform-state"
  db_remote_state_key    = "terraform-example/prod/storages/mysql/terraform.tfstate"

  instance_type = "t2.mircro"
  min_size = 2
  max_size = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

