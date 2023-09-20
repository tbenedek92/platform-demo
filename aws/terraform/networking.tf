locals {
  # Define CIDR blocks for the VPC and subnets
  vpc_cidr = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

# Create a new VPC
resource "aws_vpc" "this" {
  cidr_block = local.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "platform-demo-eks-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count = length(local.public_subnets)
  cidr_block = local.public_subnets[count.index]
  vpc_id = aws_vpc.this.id
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-subnet-${count.index+1}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count = length(local.private_subnets)
  cidr_block = local.private_subnets[count.index]
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = "private-subnet-${count.index+1}"
  }
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# Create route tables for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

# Associate route table with public subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
