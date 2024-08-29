module "s3" {
  source = "./modules/s3"

  application_name = var.application_name
  bucket_name      = var.bucket_name

}