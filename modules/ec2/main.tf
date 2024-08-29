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

resource "aws_security_group" "ec2_instance_sg" {
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

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name =  var.application_name

  instance_type          = var.instance_type
  vpc_security_group_ids = aws_security_group.ec2_instance_sg.id
  subnet_id              = var.subnet_id

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  associate_public_ip_address = var.associate_public_ip_address

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

  tags = {
      Name             = "${var.application_name}-instance"
      Application_Name = var.application_name
    }
}

resource "aws_lb_target_group_attachment" "attach_ec2_to_tg" {
  target_group_arn = var.target_group_arn
  target_id        = module.ec2_instance.id
  port             = 80
}