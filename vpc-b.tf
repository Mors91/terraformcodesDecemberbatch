resource "aws_vpc" "main-vpcB" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  provider             = aws.peer

  tags = merge(local.common_tags, { Name = "main-vpcB", Company = "EliteSolutionsIT", "Dummy" = "dummytag" })
}

////subnet - public
resource "aws_subnet" "main-publicb" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.33.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  provider                = aws.peer

  tags = local.common_tags
}

resource "aws_subnet" "main-public-2b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_blockB
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"
  provider                = aws.peer

  tags = local.common_tags
}

////subnet - private
resource "aws_subnet" "main-privateb" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.157.0/24"
  availability_zone = "us-east-1b"
  provider          = aws.peer

  tags = local.common_tags
}

///igw
resource "aws_internet_gateway" "igwB" {
  vpc_id   = aws_vpc.main.id
  tags     = local.common_tags
  provider = aws.peer

}

////route table
resource "aws_route_table" "rtbB" {
  vpc_id   = aws_vpc.main.id
  provider = aws.peer

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = local.common_tags
}

///subnet association
resource "aws_route_table_association" "rtb-publicb" {
  subnet_id      = aws_subnet.main-public.id
  route_table_id = aws_route_table.rtb.id
  provider       = aws.peer
}

resource "aws_route_table_association" "rtb-privateb" {
  subnet_id      = aws_subnet.main-private.id
  route_table_id = aws_route_table.rtb.id
  provider       = aws.peer
}