resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${var.application_name}-rds-subnet-group"
  subnet_ids = [
    module.vpc.data_subnet_az_a_id,
    module.vpc.data_subnet_az_b_id,
    module.vpc.data_subnet_az_c_id
  ]

  tags = {
    Name             = "${var.application_name}-rds-subnet-group"
    Application_Name = var.application_name
  }
}


resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = "${var.application_name}-rds-parameter-group"
  family      = "${var.db_engine}${var.db_engine_version}"
  description = "Custom parameter group for ${var.application_name}"

  // Add your custom parameters to the parameter group here

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "innodb_file_per_table"
    value = "1"
  }

  tags = {
    Name             = "${var.application_name}-rds-parameter-group"
    Application_Name = var.application_name
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "${var.application_name}-rds-sg"
  description = "Security group for RDS allowing EC2 instances to connect"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.enable_auto_scaling? module.compute.asg_sg_id : module.compute.ec2_instance_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name             = "${var.application_name}-rds-sg"
    Application_Name = var.application_name
  }
}


resource "aws_db_instance" "rds_instance" {
  identifier             = "${var.application_name}-rds-instance"
  allocated_storage      = 20
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_type
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.rds_parameter_group.name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  skip_final_snapshot    = true

  tags = {
    Name             = "${var.application_name}-rds-instance"
    Application_Name = var.application_name
  }
}