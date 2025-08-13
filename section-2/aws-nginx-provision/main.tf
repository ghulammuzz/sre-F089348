provider "aws" {
  region = var.aws_region
}

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"]
  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }
}

resource "aws_key_pair" "nginx_key" {
  key_name   = "nginx-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_vpc" "nginx_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "nginx-vpc" }
}

resource "aws_subnet" "nginx_subnet" {
  vpc_id                  = aws_vpc.nginx_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = { Name = "nginx-subnet" }
}

resource "aws_internet_gateway" "nginx_igw" {
  vpc_id = aws_vpc.nginx_vpc.id
}

resource "aws_route_table" "nginx_rt" {
  vpc_id = aws_vpc.nginx_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx_igw.id
  }
}

resource "aws_route_table_association" "nginx_rta" {
  subnet_id      = aws_subnet.nginx_subnet.id
  route_table_id = aws_route_table.nginx_rt.id
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow SSH & HTTP from public"
  vpc_id      = aws_vpc.nginx_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx_servers" {
  count                       = 8
  ami                         = data.aws_ami.debian.id
  instance_type               = "t2.nano"
  key_name                    = aws_key_pair.nginx_key.key_name
  subnet_id                   = aws_subnet.nginx_subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "nginx-server-${count.index + 1}"
  }
}