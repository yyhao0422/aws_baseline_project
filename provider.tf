terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }


}

provider "aws" {
  region = var.aws_region
}