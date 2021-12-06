module "vpc" {
  source            = "./aws-modules/aws-vpc"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.0.0/24"
  availability_zone = "${var.region}b"
  additional_tags = {
    "Application" = "flaskapp"
    "Name"        = "Flask-app-server"
    "Type"        = "vpc"
  }
}

module "server" {
  source               = "./aws-modules/aws-instance"
  ami                  = "ami-0fed77069cd5a6d6c"
  availability_zone    = "${var.region}b"
  instance_type        = "c4.xlarge"
  key_name             = "circleci"
  subnet_id            = module.vpc.subnet_id
  vpc_id               = module.vpc.vpc_id
  security_group_name  = "circle-ci-server-security-group"
  user_data            = local.user_data
  additional_tags = {
    "Application" = "circleci"
    "Name"        = "circleci-server"
    "Type"        = "Instance"
  }
  ingress_rule = {
    "22" = ["0.0.0.0/0"]
    "80"   = ["0.0.0.0/0"]
  }
}
    
