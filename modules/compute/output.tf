output "alb_sg_id" {
  value = module.alb.alb_sg_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_tg_arn" {
  value = module.alb.alb_tg_arn
}

output "ec2_instance_sg" {
  value = module.ec2.ec2_instance_sg
}

output "asg_sg_id" {
  value = module.asg.asg_instance_sg
}


