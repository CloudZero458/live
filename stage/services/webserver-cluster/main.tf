provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "https://github.com/CloudZero458/modules//services/webserver-cluster?ref=v0.0.1"
}

stack_name = "webservers-stage"
db_remote_state_bucket = "terraform-state-338"
db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

instance-type = "t2.micro"
min_size = 2
max_size = 2

resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"

  # references the alb_security_group_id output variable
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
