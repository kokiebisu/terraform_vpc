
resource "aws_iam_role" "terraform_private_role" {
  name               = "terraform_private_role"
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
}

resource "aws_iam_role" "s3_full_access" {
  name = "terraform_s3_full_access"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "terraform_s3_full_access"
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.terraform_private_role.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}

resource "aws_iam_instance_profile" "terraform_ec2_instance_profile" {
  name = "terraform_ec2_instance_profile"
  role = aws_iam_role.terraform_private_role.name
}

resource "aws_iam_policy" "terraform_policy" {
  name = "terraform_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}