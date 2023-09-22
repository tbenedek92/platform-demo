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
  depends_on = [ 
    aws_vpc.this
     ]
}

# Associate route table with public subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

  depends_on = [ 
    aws_subnet.public,
    aws_route_table.public
   ]
}

# Allocate an Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  depends_on = [ aws_vpc.this ]
}

# Create a NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id  # Assuming NAT Gateway is in the first public subnet

  tags = {
    "Name" = "platform-demo-eks-nat-gateway"
  }
  depends_on = [ 
    aws_eip.nat_eip,
    aws_subnet.public
   ]
}

# Create a route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    "Name" = "private-route-table"
  }

  depends_on = [ 
    aws_nat_gateway.this,
    aws_vpc.this,
   ]
}

# Associate route table with private subnets
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id

  depends_on = [ 
    aws_subnet.private,
    aws_route_table.private
   ]
}
