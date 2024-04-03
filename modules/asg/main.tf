### 오토 스케일링 그룹 생성 ###
resource "aws_autoscaling_group" "asg" {
  name                      = "blog-asg"
  vpc_zone_identifier       = var.subnet_id
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  health_check_type         = "ELB" # LB를 통해서 상태 확인
  health_check_grace_period = 300
  target_group_arns         = [var.target_arn]

  launch_template {
    id      = var.blog_tmp
    version = "$Latest"
  }
}

### 오토 스케일링 정책 ###
resource "aws_autoscaling_policy" "add_instance" {
  name                      = "add-instance"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization" # ASG 평균 CPU 사용률
    }
    target_value = 50.0 # CPU 사용률 50%
  }
}

### Lambda 트리거 알람 ###
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_high" {
  alarm_name          = "cpu_alarm_high"
  comparison_operator = "GreaterThanThreshold" # 임계값보다 클 때
  evaluation_periods  = 2                      # 주기마다 2번 검사
  metric_name         = "CPUUtilization"       # CPU 모니터링
  namespace           = "AWS/EC2"
  period              = 300 # 주기 설정 300초
  statistic           = "Average"
  threshold           = 50 # CPU 사용률 50%
  alarm_actions       = [aws_autoscaling_policy.add_instance.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}