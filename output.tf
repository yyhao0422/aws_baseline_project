output "alb_dns_name" {
  value       = aws_lb.application_lb.dns_name
  description = "The DNS name of the ALB"
}