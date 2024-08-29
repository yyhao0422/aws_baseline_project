module "alb" {
  source = "./modules/alb"

  application_name = var.application_name
  vpc_id           = module.vpc.vpc_id
  subnet_ids = [
    module.vpc.public_subnet_az_a_id,
    module.vpc.public_subnet_az_b_id,
    module.vpc.public_subnet_az_c_id
  ]

} 