# (1) Internet VPC
resource "aws_vpc" "lmy-terraform-test" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "lmy-terraform-test"
  }
}

# (2) Subnets
resource "aws_subnet" "lmy-tf-public-1" {
  vpc_id                  = aws_vpc.lmy-terraform-test.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "lmy-tf-public-1"
  }
}

resource "aws_subnet" "lmy-tf-private-1" {
  vpc_id                  = aws_vpc.lmy-terraform-test.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "lmy-tf-private-1"
  }
}

# ex) 새 Variable type 정의 - 진수의 설명?
resource "aws_subnet" "jinsu" {
  count = length(var.SUBNET_AZ_LIST)
  vpc_id = aws_vpc.lmy-terraform-test.id

  cidr_block = var.SUBNET_AZ_LIST[count.index].cidr_block
  map_public_ip_on_launch = var.SUBNET_AZ_LIST[count.index].map_public_ip_on_launch
  availability_zone = var.SUBNET_AZ_LIST[count.index].availability_zone

}
# ex end

# (3) Internet GW
resource "aws_internet_gateway" "lmy-tf-gw" {
  vpc_id = aws_vpc.lmy-terraform-test.id

  tags = {
    Name = "lmy-tf"
  }

}

# (4) Route Tables
resource "aws_route_table" "lmy-tf-public-rt" {
  vpc_id = aws_vpc.lmy-terraform-test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lmy-tf-gw.id
  }

  tags = {
    Name = "lmy-tf-public-rt"
  }

}

resource "aws_route_table" "lmy-tf-private-rt" {
  vpc_id = aws_vpc.lmy-terraform-test.id

  tags = {
    Name = "lmy-tf-private-rt"
  }
}

# (5) Route associations 
resource "aws_route_table_association" "lmy-tf-public-1-rta" {
  subnet_id      = aws_subnet.lmy-tf-public-1.id
  route_table_id = aws_route_table.lmy-tf-public-rt.id
}

resource "aws_route_table_association" "lmy-tf-private-1-rta" {
  subnet_id      = aws_subnet.lmy-tf-private-1.id
  route_table_id = aws_route_table.lmy-tf-private-rt.id
}
