variable "provider" {
  description = "Cloud provider: aws or openshift"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

resource "aws_vpc" "main" {
  count      = "${var.provider == "aws" ? 1 : 0}"
  cidr_block = var.cidr_block
}

resource "aws_subnet" "subnet" {
  count     = "${var.provider == "aws" ? 1 : 0}"
  vpc_id    = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}