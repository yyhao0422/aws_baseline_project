variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to deploy the EC2 instance"
  type        = string 
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy the EC2 instance"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The security group ID for the ALB"
  type        = string
}

variable "alb_tg_arn" {
  description = "The target group ARN for the ALB"
  type        = string
}