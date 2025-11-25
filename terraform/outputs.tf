output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = [for s in aws_subnet.public : s.id] }
output "private_subnet_ids" { value = [for s in aws_subnet.private : s.id] }
output "alb_dns" { value = aws_lb.alb.dns_name }
output "ec2_asg_name" { value = aws_autoscaling_group.app_asg.name }
output "rds_endpoint" { value = aws_db_instance.mysql.endpoint }
output "s3_bucket" { value = aws_s3_bucket.static_logs.bucket }
