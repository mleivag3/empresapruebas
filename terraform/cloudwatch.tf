locals {
  ec2_asg_name = aws_autoscaling_group.app_asg.name
  alb_arn = aws_lb.alb.arn
  rds_id  = aws_db_instance.mysql.id
}

resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "${var.project}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0, y = 0, width = 12, height = 6,
        properties = {
          view = "timeSeries",
          title = "EC2 CPU (ASG instances)",
          region = var.region,
          metrics = [
            [ "AWS/EC2","CPUUtilization","AutoScalingGroupName", local.ec2_asg_name ]
          ]
        }
      },
      {
        type = "metric",
        x = 12, y = 0, width = 12, height = 6,
        properties = {
          view = "timeSeries",
          title = "ALB Latency",
          region = var.region,
          metrics = [[ "AWS/ApplicationELB","TargetResponseTime","LoadBalancer", aws_lb.alb.arn_suffix ]]
        }
      },
      {
        type = "metric",
        x = 0, y = 6, width = 12, height = 6,
        properties = {
          view = "timeSeries",
          title = "RDS Connections",
          region = var.region,
          metrics = [[ "AWS/RDS","DatabaseConnections","DBInstanceIdentifier", aws_db_instance.mysql.id ]]
        }
      }
    ]
  })
}
