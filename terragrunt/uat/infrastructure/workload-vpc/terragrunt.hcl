include {
  path = find_in_parent_folders()
}
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//?ref=v3.11.0"
  extra_arguments "init_args" {
    commands = [
      "init"
    ]
    arguments = [
    ]
  }
}
inputs = {
  name = "workload-vpc"
  cidr = "10.53.82.0/24"
  azs             = ["ap-south-1a", "ap-south-1b"]
  #public subnets for temp access
  public_subnets    = ["10.53.82.128/28", "10.53.82.144/28"]
  #private subnet for eks workload, Last 2 subnets are for db
  private_subnets   = ["10.53.82.0/26", "10.53.82.64/26","10.53.82.160/28","10.53.82.176/28"]

  enable_nat_gateway    = true
  single_nat_gateway    = true
  enable_dns_hostnames  = true
  enable_dns_support    = true
  tags = {
    Name        = "ca-workload-vpc"
    Owner       = "DevOps"
    Project     = "CADIY"
    Environment = "UAT"
  }
}