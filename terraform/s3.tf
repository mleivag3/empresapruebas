resource "random_id" "s3_id" { byte_length = 4 }

resource "aws_s3_bucket" "static_logs" {
  bucket = "${var.project}-static-logs-${random_id.s3_id.hex}"
  acl = "private"
  force_destroy = true
  tags = { Name = "${var.project}-s3" }
}

output "s3_bucket" { value = aws_s3_bucket.static_logs.bucket }
