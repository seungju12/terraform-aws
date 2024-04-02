resource "aws_lb" "alb" {
  name               = "blog-alb"
  subnets            = var.subnet_id
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb-sg.id]
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}

resource "aws_security_group" "alb-sg" {
  name   = "blog-alb-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "port-80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-sg.id
}

resource "aws_security_group_rule" "outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-sg.id
}

resource "aws_lb_target_group" "target" {
  name        = "blog-alb-target-group"
  vpc_id      = var.vpc_id
  port        = 80 # ami 변경 시 3000으로 수정
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    enabled = true
    path = "/"
  }
}