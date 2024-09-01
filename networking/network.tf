provider "aws" {
  region = "eu-west-1"  # Replace with your preferred region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
    Environment = "test"
  }
}

# Create two private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet1"
    Environment = "test"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet2"
    Environment = "test"
  }
}

# Create route tables for private subnets (no routes to the internet)
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "PrivateRouteTable1"
    Environment = "test"
  }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "PrivateRouteTable2"
    Environment = "test"
  }
}

# Associate route tables with private subnets
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}

data "aws_availability_zones" "available" {}
