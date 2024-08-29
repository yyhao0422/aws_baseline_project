variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
}

variable "add_random_prefix" {
  description = "The random prefix to use for the bucket name"
  type        = bool
  default = true
}