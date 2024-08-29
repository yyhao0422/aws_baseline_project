variable "application_name" {
  description = "The name of the application"
  type = string
}

variable "db_engine" {
  description = "The database engine to use for the RDS instance"
  type = string
}

variable "db_engine_version" {
  description = "The version of the database engine to use for the RDS instance"
  type = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs to launch the RDS instance into"
  type = list(string)
}

variable "vpc_id" {
  description = "The VPC ID to launch the RDS instance into"
  type = string
}

variable "db_instance_type" {
  description = "The instance type to use for the RDS instance"
  type = string
}

variable "db_username" {
  description = "The username for the master DB user"
  type = string
}

variable "db_password" {
  description = "The password for the master DB user"
  type = string
}

variable "instance_sg_id" {
  description = "The security group ID that will connect to the RDS instance"
  type = string
}