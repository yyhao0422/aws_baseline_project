module "alb" {
  source = "../alb"

  application_name = var.application_name
  vpc_id           = var.vpc_id
  subnet_ids = var.alb_subnet_ids
}

module "asg" {
  source = "../asg"

  count = var.enable_auto_scaling ? 1 : 0

  application_name = var.application_name
  vpc_id           = var.vpc_id
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  subnet_ids = var.asg_subnet_ids
  alb_sg_id = module.alb.alb_sg_id
  alb_tg_arn = module.alb.alb_tg_arn

}


module "ec2" {
  source = "../ec2"

  count = var.enable_auto_scaling ? 0 : 1

  application_name = var.application_name  
  vpc_id           = var.vpc_id
  subnet_id        = var.asg_subnet_ids[0]
  instance_type    = var.instance_type
  alb_sg_id = module.alb.alb_sg_id
  associate_public_ip_address = false
  target_group_arn = module.alb.alb_tg_arn
}