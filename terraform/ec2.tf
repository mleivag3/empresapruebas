# Security group for EC2 instance
resource "aws_security_group" "app_sg" {
  name = "${var.project}-app-sg"
  vpc_id = aws_vpc.this.id
  description = "instancia de pruebas para empresa"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description = "From ALB"
  }

  # SSH from admin CIDR only if provided
  dynamic "ingress" {
    for_each = var.admin_cidr != "" ? [1] : []
    content {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = [var.admin_cidr]
      description = "SSH from admin CIDR"
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter { name = "name", values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] }
}

# IAM instance profile must exist (defined in iam.tf)
# Launch Template for ASG
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_ec2
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.app_sg.id]
  }

  key_name = var.key_name != "" ? var.key_name : null

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              systemctl enable apache2
              echo "<h1>Demo app - $(hostname)</h1>" > /var/www/html/index.html
              EOF
  )
}

# Auto Scaling Group (private subnets)
resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.project}-asg"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = [for s in aws_subnet.private : s.id]
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.tg.arn]
  health_check_type = "ELB"
  force_delete = true
  tags = [
    {
      key                 = "Name"
      value               = "${var.project}-app-asg"
      propagate_at_launch = true
    }
  ]
}

output "ec2_asg_name" { value = aws_autoscaling_group.app_asg.name }
