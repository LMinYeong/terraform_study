provider "aws" {
  region = "ap-southeast-1"
  # region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block       = "172.165.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test"
  }

}