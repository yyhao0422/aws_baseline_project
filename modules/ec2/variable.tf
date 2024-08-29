variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
}


variable "subnet_id" {
  description = "The subnet ID to deploy the EC2 instance"
  type        = string
}

variable "vpc_id" {
    description = "The VPC ID to deploy the EC2 instance"
    type        = string
}

variable "alb_sg_id" {
    description = "The security group ID for the ALB"
    type        = string
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the EC2 instance"
  type        = bool
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}
