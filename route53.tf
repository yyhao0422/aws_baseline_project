
resource "aws_route53_zone" "private_hosted_zone" {
  name = "example.com"

  force_destroy = true

  vpc {
    vpc_id = aws_vpc.application_vpc.id
  }

  tags = {
    Name             = "${var.application_name}-cloudtrail-logs"
    Application_Name = var.application_name
  }

}