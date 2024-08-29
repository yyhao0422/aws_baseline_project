output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_dns_name" {
  value = aws_lb.application_lb.dns_name
}

output "alb_tg_arn" {
  value = aws_lb_target_group.application_tg.arn
}
