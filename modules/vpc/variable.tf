variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy the VPC"
  type        = string
}
