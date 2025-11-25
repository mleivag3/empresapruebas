# EC2 role to allow limited S3 access
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service"; identifiers = ["ec2.amazonaws.com"] }
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Improved least-privilege policy for S3 + CloudWatch PutMetric (example)
resource "aws_iam_policy" "ec2_s3_policy" {
  name = "${var.project}-ec2-s3"
  description = "Allow EC2 to put/get objects in specific bucket and send CloudWatch metrics"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.static_logs.arn,
          "${aws_s3_bucket.static_logs.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  role = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
