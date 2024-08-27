resource "random_id" "simple_bucket_hex" {
  byte_length = 4
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = "${lower(var.application_name)}-private-${random_id.simple_bucket_hex.hex}" # Replace with a unique bucket name

  force_destroy = true

  tags = {
    Name             = "${var.application_name}-bucket"
    Application_Name = var.application_name
  }

}