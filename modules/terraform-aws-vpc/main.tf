resource "aws_vpc" "seoul-vpc" {
  provider = aws.seoul
  cidr_block = "10.2.0.0/16"
}

resource "aws_vpc" "osaka-vpc" {
  provider = aws.osaka
  cidr_block = "10.3.0.0/16"
}

resource "aws_subnet" "seoul-subnet" {
  for_each = var.seoul-subnets
  provider = aws.seoul
  vpc_id = aws_vpc.seoul-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
}

resource "aws_subnet" "osaka-subnet" {
  for_each = var.osaka-subnets
  provider = aws.osaka
  vpc_id = aws_vpc.osaka-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "seoul-igw" {
  provider = aws.seoul
  vpc_id = aws_vpc.seoul-vpc.id
}

resource "aws_internet_gateway" "osaka-igw" {
  provider = aws.osaka
  vpc_id = aws_vpc.osaka-vpc.id
}

resource "aws_route_table" "seoul-rtb" {
  provider = aws.seoul
  vpc_id = aws_vpc.seoul-vpc.id
}

resource "aws_route_table" "osaka-rtb" {
  provider = aws.osaka
  vpc_id = aws_vpc.osaka-vpc.id
}

resource "aws_route_table_association" "seoul-sub-to-rtb" {
  provider = aws.seoul
  for_each = var.seoul-subnets
  subnet_id = aws_subnet.seoul-subnet[each.key].id
  route_table_id = aws_route_table.seoul-rtb.id
}

resource "aws_route_table_association" "osaka-sub-to-rtb" {
  provider = aws.osaka
  for_each = var.osaka-subnets
  subnet_id = aws_subnet.osaka-subnet[each.key].id
  route_table_id = aws_route_table.osaka-rtb.id
}

resource "aws_route" "seoul-route" {
  provider = aws.seoul
  route_table_id = aws_route_table.seoul-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.seoul-igw.id
}

resource "aws_route" "osaka-route" {
  provider = aws.osaka
  route_table_id = aws_route_table.osaka-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.osaka-igw.id
}