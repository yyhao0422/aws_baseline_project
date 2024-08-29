output "asg_instance_sg" {
    value = aws_security_group.ec2_instance_lt_sg.id
}