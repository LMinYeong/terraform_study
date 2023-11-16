# (1) Internet VPC
resource "aws_vpc" "lmy-terraform-test" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "lmy-terraform-test"
  }
}

# (2) Subnets
resource "aws_subnet" "lmy-tf-public-1" {
  vpc_id = aws_vpc.lmy-terraform-test.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1a"

    tags = {
      Name = "lmy-tf-public-1"
    }
}

resource "aws_subnet" "lmy-tf-private-1" {
  vpc_id = aws_vpc.lmy-terraform-test.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "lmy-tf-private-1"
  }
}

# (3) Internet GW
resource "aws_internet_gateway" "lmy-tf-gw" {
  vpc_id = aws_vpc.lmy-terraform-test.id
  
  tags = {
    Name = "lmy-tf"
  }
}

# (4) Route Tables
resource "aws_route_table" "lmy-tf-public" {
  vpc_id = aws_vpc.lmy-terraform-test.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lmy-tf-gw.id 
  }
  
 tags = {
   Name = "lmy-tf-public-1"
 }

}

resource "aws_route_table" "lmy-tf-private" {
  vpc_id = aws_vpc.lmy-terraform-test.id
}

# (5) Route associations public
resource "aws_route_table_association" "lmy-tf-public-1-rta" {
  subnet_id = aws_subnet.lmy-tf-public-1.id
  route_table_id = aws_route_table.lmy-tf-public
}

resource "aws_route_table_association" "lmy-tf-private-1-rta" {
  subnet_id = aws_subnet.lmy-tf-public-1.id
  route_table_id = aws_route_table.lmy-tf-public
}