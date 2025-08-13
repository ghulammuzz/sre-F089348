terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.debian.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name          = "${var.env}-web"
    Environment   = var.env
    CostCenter    = var.cost_center
    Project       = var.project
  }
}

