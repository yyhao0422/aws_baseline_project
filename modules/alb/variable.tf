variable "application_name" {
  description = "The name of the application"
  type        = string    
}

variable "vpc_id" {
  description = "The VPC ID to deploy the EC2 instance"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy the EC2 instance"
  type        = list(string)
  
}