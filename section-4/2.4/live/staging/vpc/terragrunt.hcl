include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  aws_region = "ap-southeast-1"
  cidr_block = "10.0.0.0/16"
  env        = "staging"
}
