resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
  enable_deletion_protection = false
  idle_timeout       = 3600  # Timeout in seconds (60 minutes)
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "target_group" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = "200"
      content_type = "text/plain"
      message_body = "Hello from ALB"
    }
  }
}

resource "aws_lb_target_group_attachment" "web_server" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.ec2_instance_id
  port             = 80
}

resource "aws_security_group" "alb_sg" {
  name        = "my-alb-sg"
  description = "Security group for the application load balancer"
  vpc_id      = aws_vpc.main_vpc.id
}
resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]  # Allow traffic from anywhere
}
resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  # Allow all protocols
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]  # Allow traffic to anywhere
}
