
resource "aws_route53_zone" "private_hosted_zone" {
  name = "example.ecv.com"

  force_destroy = true

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = {
    Name             = "${var.application_name}-cloudtrail-logs"
    Application_Name = var.application_name
  }

}