resource "aws_iam_role" "ec2_role" {
  name = "${var.application_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name             = "${var.application_name}-ec2-role"
    Application_Name = var.application_name
  }
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.application_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "ec2_instance_lt_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name             = "${var.application_name}-ec2-sg"
    Application_Name = var.application_name
  }
}

resource "aws_launch_template" "application_lt" {
  name_prefix   = "${var.application_name}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_instance_lt_sg.id]
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  sudo yum install -y httpd mysql
  sudo systemctl enable httpd
  sudo systemctl start httpd

  INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  AVAILABILITY_ZONE=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)

  cat <<EOT > /var/www/html/index.html
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Home</title>
    </head>
    <body>
      <h1>Instance ID: $INSTANCE_ID</h1>
      <h2>Availability Zone: $AVAILABILITY_ZONE</h2>
    </body>
  </html>
  EOT

  echo "User data script completed"
  EOF
  )
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name             = "${var.application_name}-instance"
      Application_Name = var.application_name
    }
  }
}

resource "aws_autoscaling_group" "application_asg" {
  desired_capacity = 3
  max_size         = 3
  min_size         = 3
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.application_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.alb_tg_arn]

  tag {
    key                 = "Name"
    value               = "${var.application_name}-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "attach_asg_to_tg" {
  autoscaling_group_name = aws_autoscaling_group.application_asg.id
  lb_target_group_arn    = var.alb_tg_arn
}
