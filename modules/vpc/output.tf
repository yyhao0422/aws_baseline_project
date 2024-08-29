output "vpc_id" {
  value = aws_vpc.application_vpc.id
}

output "public_subnet_az_a_id" {
  value = aws_subnet.PUBLIC_SUBNET_AZ_A.id
}

output "public_subnet_az_b_id" {
  value = aws_subnet.PUBLIC_SUBNET_AZ_B.id
}

output "public_subnet_az_c_id" {
  value = aws_subnet.PUBLIC_SUBNET_AZ_C.id
}

output "private_subnet_az_a_id" {
  value = aws_subnet.PRIVATE_SUBNET_AZ_A.id
}

output "private_subnet_az_b_id" {
  value = aws_subnet.PRIVATE_SUBNET_AZ_B.id
}

output "private_subnet_az_c_id" {
  value = aws_subnet.PRIVATE_SUBNET_AZ_C.id
}

output "data_subnet_az_a_id" {
  value = aws_subnet.DATA_SUBNET_AZ_A.id
}

output "data_subnet_az_b_id" {
  value = aws_subnet.DATA_SUBNET_AZ_B.id
}

output "data_subnet_az_c_id" {
  value = aws_subnet.DATA_SUBNET_AZ_C.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}



