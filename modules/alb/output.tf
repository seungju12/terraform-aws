output "alb-sg_id" {
  value = aws_security_group.alb-sg.id
}

output "target_arn" {
  value = aws_lb_target_group.target.arn
}
