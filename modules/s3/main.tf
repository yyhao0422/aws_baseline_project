resource "random_id" "simple_bucket_hex" {
  byte_length = 4
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = "${lower(var.bucket_name)}-${var.add_random_prefix ? random_id.simple_bucket_hex.hex : ""}" 

  force_destroy = true

  tags = {
    Name             = "${var.application_name}-bucket"
    Application_Name = var.application_name
  }

}