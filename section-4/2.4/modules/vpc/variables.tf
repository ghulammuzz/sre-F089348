variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "env" {
  type        = string
  description = "Environment name"
}
