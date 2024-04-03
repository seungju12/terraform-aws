### 템플릿에 적용될 보안 그룹 생성 ###
resource "aws_security_group" "tmp-sg" {
  name   = "blog-tmp-sg"
  vpc_id = var.vpc_id
}

### 인바운드 포트 80 허용 ###
resource "aws_security_group_rule" "port-80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.tmp-sg.id
  # source_security_group_id = var.alb-sg_id
}

### 인바운드 포트 3000 허용 ###
resource "aws_security_group_rule" "port-3000" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.tmp-sg.id
  # source_security_group_id = var.alb-sg_id
}

### 아웃바운드 모든 트래픽 허용 ###
resource "aws_security_group_rule" "outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tmp-sg.id
}

### 시작 템플릿 생성 ###
resource "aws_launch_template" "tmp" {
  name                   = "blog"
  instance_type          = "t2.small"
  image_id               = "ami-0c5725ed1d11eebfa" # public ami-id
  vpc_security_group_ids = [aws_security_group.tmp-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              cd /home/ec2-user/blog_site
              npm run dev
              EOF

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      delete_on_termination = true # 인스턴스 삭제 시 볼륨 삭제
    }
  }
}