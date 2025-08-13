variable "aws_region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "env" {
  type = string
}

variable "cost_center" {
  description = "Cost center tag for tracking"
  type        = string
}

variable "project" {
  description = "Project name for tagging"
  type        = string
}