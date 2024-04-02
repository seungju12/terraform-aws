output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_id" {
  value = values({ for key, subnet in aws_subnet.subnet : key => subnet.id })
}