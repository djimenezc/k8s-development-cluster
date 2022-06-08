provider "aws" {
  profile = "default"
  region  = var.aws_region
  assume_role {
    # This is a variable based on the AWS account
    role_arn     = var.jenkins_role_arn
    session_name = "terraform"
  }
}

resource "aws_iam_policy" "ec2-start-stop" {
  name        = "ec2-start-stop"
  path        = "/"
  description = "Ec2 start-stop policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow"
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource : "arn:aws:logs:*:*:*"
      },
      {
        Effect : "Allow"
        Action : [
          "ec2:Start*",
          "ec2:Stop*"
        ]
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2-start-stop" {
  name = "ec2-start-stop"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Testing = "true"
    Owner   = "david"
  }
}

resource "aws_iam_role_policy_attachment" "ec2-start-stop" {
  role       = aws_iam_role.ec2-start-stop.name
  policy_arn = aws_iam_policy.ec2-start-stop.arn
}