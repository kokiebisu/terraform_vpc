resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.terraform_vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.0.0/24"
  tags = {
    "Name" = "PublicA"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.terraform_vpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.1.0/24"
  tags = {
    "Name" = "PublicB"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.terraform_vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.16.0/20"
  tags = {
    "Name" = "PrivateA"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.terraform_vpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.32.0/20"
  tags = {
    "Name" = "PrivateB"
  }
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