### 지역 변수 정의 ###
locals {
  vpc = data.aws_region.current.name == var.region_1 ? "10.1.0.0/16" : "10.2.0.0/16"

  subnet = data.aws_region.current.name == var.region_1 ? {
    "${var.region_1}a" = "10.1.1.0/24"
    "${var.region_1}c" = "10.1.2.0/24"
    } : {
    "${var.region_2}a" = "10.2.1.0/24"
    "${var.region_2}c" = "10.2.2.0/24"
  }
}

### VPC 생성 ###
resource "aws_vpc" "vpc" {
  cidr_block = local.vpc
}

### 서브넷 생성 ###
resource "aws_subnet" "subnet" {
  for_each                = local.subnet
  cidr_block              = each.value
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.key
  map_public_ip_on_launch = true
}

### 인터넷 게이트웨이 생성 ###
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

### 라우팅 테이블 생성 ###
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
}

### 서브넷과 라우팅 테이블 연결 ###
resource "aws_route_table_association" "connect-rtb" {
  for_each       = local.subnet
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.rtb.id
}

### 모든 트래픽 인터넷 게이트웨이로 라우팅 ###
resource "aws_route" "route" {
  route_table_id         = aws_route_table.rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}