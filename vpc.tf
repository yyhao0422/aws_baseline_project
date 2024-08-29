module "vpc" {
  source = "./modules/vpc"

  application_name = var.application_name
  cidr_block       = var.cidr_block
  aws_region       = var.aws_region

}
