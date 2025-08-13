include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/ec2_asg"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  aws_region     = "ap-southeast-1"
  instance_type  = "t2.micro"
  subnet_id      = dependency.vpc.outputs.public_subnet_id
  env            = "prod"
  project        = "finance-service"
  cost_center    = "FIN001-FinancePlatform"
}
