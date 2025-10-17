variable "aws_region" { type = string  default = "eu-central-1" }
variable "subnet_id"  { type = string  description = "Existing subnet id (in a public subnet)" }
variable "instance_type" { type = string default = "t3.micro" }
variable "image" { type = string  description = "ghcr.io/shayle664/shay-final-project:latest" }
variable "container_port" { type = number default = 5007 }
variable "exposed_port"   { type = number default = 80 }
