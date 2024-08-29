module "compute" {
  source = "./modules/compute"

  application_name = var.application_name
    vpc_id           = module.vpc.vpc_id
    alb_subnet_ids = [
        module.vpc.public_subnet_az_a_id,
        module.vpc.public_subnet_az_b_id,
        module.vpc.public_subnet_az_c_id
    ]
    asg_subnet_ids = [
        module.vpc.private_subnet_az_a_id,
        module.vpc.private_subnet_az_b_id,
        module.vpc.private_subnet_az_c_id
    ]
    ami_id           = var.ami_id
    instance_type    = var.instance_type
    enable_auto_scaling = var.enable_auto_scaling
}