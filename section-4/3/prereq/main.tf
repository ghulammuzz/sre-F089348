provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  required_version = ">= 1.12, < 1.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "aws_s3_bucket" "tf_state" {
  bucket = "finance-service-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name       = "Finance Service TF State"
    Department = "Finance"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "finance-service-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name       = "Finance Service TF Lock"
    Department = "Finance"
  }
}
