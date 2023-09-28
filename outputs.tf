output "test" {
  value = aws_vpc.main
}

output "internetgateway" {
  value = aws_internet_gateway.igw
}

output "subnets" {
  value = aws_subnet.vpc_subnets
}

output "routetable" {
  value = aws_route_table.vpc1_pub_rt
}

# output "subnets1" {
#   value = aws_subnet.vpc_subnets1
# }

output "test2" {
  value = aws_security_group.my_security_group
}
