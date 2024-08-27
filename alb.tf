
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.application_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name             = "${var.application_name}-alb-sg"
    Application_Name = var.application_name
  }
}

resource "aws_lb" "application_lb" {
  name               = "${var.application_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.PUBLIC_SUBNET_AZ_A.id,
    aws_subnet.PUBLIC_SUBNET_AZ_B.id,
    aws_subnet.PUBLIC_SUBNET_AZ_C.id
  ]

  tags = {
    Name             = "${var.application_name}-alb"
    Application_Name = var.application_name
  }
}


resource "aws_lb_target_group" "application_tg" {
  name     = "${var.application_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.application_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name             = "${var.application_name}-tg"
    Application_Name = var.application_name
  }
}

resource "aws_lb_listener" "application_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_tg.arn
  }

  tags = {
    Name             = "${var.application_name}-listener"
    Application_Name = var.application_name
  }
}

