resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "subnet" {
  for_each          = var.subnet
  cidr_block        = each.value
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "connect-rtb" {
  for_each       = var.subnet
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}