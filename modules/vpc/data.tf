data "aws_availability_zones" "specific_region_available_zone" {
  state = "available"
}

data "aws_caller_identity" "current" {}