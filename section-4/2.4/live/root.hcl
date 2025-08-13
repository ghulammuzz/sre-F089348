remote_state {
  backend = "s3"
  config = {
    bucket         = "finance-service-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "finance-service-terraform-lock"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "ap-southeast-1"
  }
  EOF
}