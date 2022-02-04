resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"


  tags = {
    Name        = "main-vpc"
    Env         = "stage"
    ManagedWith = "Terraform"

  }
}

////subnet - public
resource "aws_subnet" "main-public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name        = "public-subnet"
    Env         = "stage"
    ManagedWith = "Terraform"

  }
}

////subnet - private
resource "aws_subnet" "main-private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "private-subnet"
    Env         = "stage"
    ManagedWith = "Terraform"
  }
}

///igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "igw"
    Env         = "stage"
    ManagedWith = "Terraform"
  }
}

////route table
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "route-table"
    Env         = "stage"
    ManagedWith = "Terraform"
  }
}

///subnet association
resource "aws_route_table_association" "rtb-public" {
  subnet_id      = aws_subnet.main-public.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtb-private" {
  subnet_id      = aws_subnet.main-private.id
  route_table_id = aws_route_table.rtb.id
}