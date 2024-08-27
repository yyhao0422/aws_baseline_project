variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "application_name" {
  description = "The name of the application"
  type        = string
  default     = "IaC-application"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0c8e23f950c7725b9"
}

variable "private_hosted_zone_name" {
  description = "The name of the private hosted zone"
  type        = string
  default     = "example.com"
}

variable "db_engine" {
  description = "The DB engine family for the RDS instance"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The DB engine version for the RDS instance"
  type        = string
  default     = "8.0"
  
}


variable "db_username" {
  description = "The username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  default = "PassWord123"
}

variable "db_instance_type" {
  description = "The instance type for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}