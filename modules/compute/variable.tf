variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to deploy the EC2 instance"
  type        = string
}

variable "alb_subnet_ids" {
  description = "The subnet IDs to deploy the ALB"
}

variable "asg_subnet_ids" {
  description = "The subnet IDs to deploy the EC2 instance"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
}

variable "enable_auto_scaling"{
    description = "Turn on auto scaling"
    type        = bool
}