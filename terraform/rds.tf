resource "aws_db_subnet_group" "this" {
  name = "${var.project}-dbsubnet"
  subnet_ids = [for s in aws_subnet.private : s.id]
  tags = { Name = "${var.project}-dbsubnet" }
}

resource "aws_security_group" "rds_sg" {
  name = "${var.project}-rds-sg"
  vpc_id = aws_vpc.this.id
  description = "Allow MySQL from app SG"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mysql" {
  identifier = "${var.project}-db"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = var.rds_instance_class
  allocated_storage = 20
  name = "demodb"
  username = var.db_username
  password = var.db_password
  skip_final_snapshot = true

  #bk M-az,encrip
  multi_az = true
  storage_encrypted = true
  backup_retention_period = 7

  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible = false
  tags = { Name = "${var.project}-rds" }
}

