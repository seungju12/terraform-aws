resource "aws_security_group" "tmp-sg" {
  name   = "blog-tmp-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "port-80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.tmp-sg.id
  # source_security_group_id = var.alb-sg_id
}

resource "aws_security_group_rule" "port-3000" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.tmp-sg.id
  # source_security_group_id = var.alb-sg_id
}

resource "aws_security_group_rule" "outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tmp-sg.id
}

resource "aws_launch_template" "tmp" {
  name                   = "blog"
  instance_type          = "t2.small"
  image_id               = "ami-0c5725ed1d11eebfa"
  vpc_security_group_ids = [aws_security_group.tmp-sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      delete_on_termination = true # 인스턴스 삭제 시 볼륨 삭제
    }
  }
}