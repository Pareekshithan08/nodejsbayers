provider "aws" {
  region = "us-west-1"
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with resources in this module"
  type        = string
}

resource "aws_alb" "app" {

    name        = "cb-load-balancer"
    subnets         = aws_subnet.public.*.id
    security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
    name        = "cb-target-group"
    port        = 3000
    protocol    = "HTTP"
    vpc_id      = aws_vpc.main.id
    target_type = "ip"

    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path                = var.health_check_path
        unhealthy_threshold = "2"
    }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}