terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = var.aws_region }

# Get details of the provided subnet
data "aws_subnet" "chosen" { id = var.subnet_id }

# Security group: allow HTTP in, allow all egress
resource "aws_security_group" "app_sg" {
  name        = "fp-web-sg"
  description = "Allow HTTP"
  vpc_id      = data.aws_subnet.chosen.vpc_id

  ingress {
    from_port   = var.exposed_port
    to_port     = var.exposed_port
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

# Latest Amazon Linux 2023
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"]
  filter { name = "name" values = ["al2023-ami-*-x86_64"] }
}

# User data renders our install+run script
locals {
  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    image          = var.image
    container_port = var.container_port
    exposed_port   = var.exposed_port
  })
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  key_name               = var.key_name

  user_data = local.user_data

  tags = {
    Name = "shay-final-project"
  }
}

