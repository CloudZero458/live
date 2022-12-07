provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
}

resource_name = "webservers-prod"
db_remote_state_bucket = terraform-state-338
db_remote_state_key = "prod/data-stores/mysql//webserver-cluster/terraform.tfstate"

instance_type = "t2.micro"
min_size = 2
max_size = 10

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  autoscaling_group_name = module.webserver_cluster.asg_name
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *" # run at 9:00 a.m. everyday

}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  autoscaling_group_name = module.webserver_cluster.asg_name
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *" # run at 5:00 p.m. everyday

}
