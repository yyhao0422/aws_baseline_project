resource "aws_vpc" "application_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name             = "${var.application_name}-vpc"
    Application_Name = var.application_name
  }
}

resource "aws_subnet" "PUBLIC_SUBNET_AZ_A" {

  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 0)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[0]

  tags = {
    Name             = "${var.application_name}-PUBLIC_SUBNET_AZ_A"
    Application_Name = var.application_name
  }
}

resource "aws_subnet" "PUBLIC_SUBNET_AZ_B" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 1)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[1]

  tags = {
    Name             = "${var.application_name}-PUBLIC_SUBNET_AZ_B"
    Application_Name = var.application_name
  }
}

resource "aws_subnet" "PUBLIC_SUBNET_AZ_C" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 2)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[2]

  tags = {
    Name             = "${var.application_name}-PUBLIC_SUBNET_AZ_C"
    Application_Name = var.application_name
  }
}


resource "aws_subnet" "PRIVATE_SUBNET_AZ_A" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 3)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[0]

  tags = {
    Name             = "${var.application_name}-PRIVATE_SUBNET_AZ_A"
    Application_Name = var.application_name
  }
}

resource "aws_subnet" "DATA_SUBNET_AZ_A" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 4)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[0]

  tags = {
    Name             = "${var.application_name}-DATA_SUBNET_AZ_A"
    Application_Name = var.application_name
  }
}

resource "aws_subnet" "PRIVATE_SUBNET_AZ_B" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 5)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[1]

  tags = {
    Name             = "${var.application_name}-PRIVATE_SUBNET_AZ_B"
    Application_Name = var.application_name
  }
}

resource "aws_subnet" "DATA_SUBNET_AZ_B" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 6)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[1]

  tags = {
    Name             = "${var.application_name}-DATA_SUBNET_AZ_B"
    Application_Name = var.application_name
  }
}

resource "aws_subnet" "PRIVATE_SUBNET_AZ_C" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 7)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[2]

  tags = {
    Name             = "${var.application_name}-PRIVATE_SUBNET_AZ_C"
    Application_Name = var.application_name
  }
}

resource "aws_subnet" "DATA_SUBNET_AZ_C" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 10, 8)
  availability_zone = data.aws_availability_zones.specific_region_available_zone.names[2]

  tags = {
    Name             = "${var.application_name}-DATA_SUBNET_AZ_C"
    Application_Name = var.application_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    Name             = "${var.application_name}-igw"
    Application_Name = var.application_name
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name             = "${var.application_name}-nat-eip"
    Application_Name = var.application_name
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.PUBLIC_SUBNET_AZ_A.id

  tags = {
    Name             = "${var.application_name}-nat-gw"
    Application_Name = var.application_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.application_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name             = "${var.application_name}-public-rt"
    Application_Name = var.application_name
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = {
    "PUBLIC_SUBNET_AZ_A" : aws_subnet.PUBLIC_SUBNET_AZ_A.id,
    "PUBLIC_SUBNET_AZ_B" : aws_subnet.PUBLIC_SUBNET_AZ_B.id,
    "PUBLIC_SUBNET_AZ_C" : aws_subnet.PUBLIC_SUBNET_AZ_C.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.application_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name             = "${var.application_name}-private-rt"
    Application_Name = var.application_name
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  for_each = {
    "PRIVATE_SUBNET_AZ_A" : aws_subnet.PRIVATE_SUBNET_AZ_A.id,
    "DATA_SUBNET_AZ_A" : aws_subnet.DATA_SUBNET_AZ_A.id,
    "PRIVATE_SUBNET_AZ_B" : aws_subnet.PRIVATE_SUBNET_AZ_B.id,
    "DATA_SUBNET_AZ_B" : aws_subnet.DATA_SUBNET_AZ_B.id,
    "PRIVATE_SUBNET_AZ_C" : aws_subnet.PRIVATE_SUBNET_AZ_C.id,
    "DATA_SUBNET_AZ_C" : aws_subnet.DATA_SUBNET_AZ_C.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "ec2_instance_connect_sg" {
  vpc_id = aws_vpc.application_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name             = "${var.application_name}-ec2_instance_connect_sg"
    Application_Name = var.application_name
  }
}

resource "aws_ec2_instance_connect_endpoint" "ec2_instance_connect" {
  subnet_id = aws_subnet.PRIVATE_SUBNET_AZ_A.id

  security_group_ids = [aws_security_group.ec2_instance_connect_sg.id]

  tags = {
    Name             = "${var.application_name}-ec2-instance-connect"
    Application_Name = var.application_name
  }
}

resource "aws_vpc_endpoint" "s3_gateway_endpoint" {
  vpc_id            = aws_vpc.application_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_rt.id]

  tags = {
    Name             = "${var.application_name}-s3-endpoint"
    Application_Name = var.application_name
  }
}