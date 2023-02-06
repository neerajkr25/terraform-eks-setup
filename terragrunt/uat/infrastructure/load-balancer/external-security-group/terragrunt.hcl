include {
  path = find_in_parent_folders()
}
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//?ref=v4.3.0"
extra_arguments "init_args" {
    commands = [
      "init"
    ]
arguments = [
    ]
  }
}
dependency "workload-vpc" {
  config_path = "../workload-vpc"
}
inputs = {
  name        = "external-security-group"
  description = "SG to use with external ALB, allow specific traffic internally but limit based on route based rules"
  vpc_id      = dependency.vpc.outputs.vpc_id
  ingress_cidr_blocks = concat(
    ["10.0.0.0/20"]
  )
 
  ingress_rules = ["http-80-tcp"]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All egress"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
tags = {
    Name        = "external-lb-security-group"
    Owner       = "<INSERT-COMPANY-NAME>"
    Contact     = "<INSERT-NAME>"
    Project     = "CADIY"
    Environment = "UAT"
  }
}