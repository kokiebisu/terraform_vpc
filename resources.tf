resource "aws_instance" "terraform_public_instance" {
  ami                         = "ami-0aeeebd8d2ab47354"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_a.id
  security_groups             = [aws_security_group.public.id]
  tags = {
    Name = "terraform_public_instance"
  }
  key_name = aws_key_pair.connector.key_name
}

resource "aws_key_pair" "connector" {
  key_name   = "connector"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdNOZiReUSDCQcVCvDaKqeUW83adcj+zuHk6r1fX2nR1bSxWLzbItJ1nKbmZzXap9SWUPhSsgxfTEBXkhQYMl0c7qiJGrybyHjBwztmDK78utBmp4E/GKNoP7my/jW6ly+Vrn8s7ny94aq4Uzk/OV5REnHkFozd9y9mXtoyCLblgGjMkKIOx48wh4yRvb8yHyviXUHbRw/kNbjfgZqcD5dzcP6nezq2uFI65wEHU8YEeoL4jbARVRJwoMEaVMa0tnOb485d9q7nHVz+T4YYmpMUbeQhwAtDN5/Wazsrr+fhM9Z19rB07yhFoYq4Iue+3m0dUUfok/aWIV4Kjwu80Hn"
}

resource "aws_instance" "terraform_private_instance" {
  ami             = "ami-0aeeebd8d2ab47354"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_a.id
  security_groups = [aws_security_group.private.id]
  tags = {
    Name = "terraform_private_instance"
  }
  iam_instance_profile = aws_iam_instance_profile.terraform_ec2_instance_profile.name
  key_name = aws_key_pair.inner_connector.key_name
}

resource "aws_key_pair" "inner_connector" {
  key_name   = "inner_connector"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCi2N7hT7gpzLniY1Pq9PEiWaNwPNOHpHiYqhd1inz2l7q58KUzacmklYctpGyxgvnJa2w2F299ccQJSwsLb7fi3gt326X+y/pUp78ZE+EYezACkhqrHhSUYfjBo3WHZLZpDjhD88OZg38Ru2moRhh3qpqrppZO8q9jzgawPIvP40ErX6xgp4v0X1jp0heFPglg1URVYOUaASsOvopJfoIl3LXm0kbOKpPFw3C/91z5+k7wKtYIIU9lqjrq1/Glt0PIEd4a8pf8fVYOHQGziccCd09RBQQqVElsqmKEsHbVazUQ0kVWefJBW2dG/bec8ctLdHxVtfwzbEZCSHhq3CUF"
}

resource "aws_security_group" "public" {
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_sg_group_public"
  }
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.terraform_vpc.cidr_block]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_sg_group_private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform_igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "private_route_table_a"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }

  tags = {
    Name = "private_route_table_b"
  }
}

resource "aws_route_table_association" "public_route_association_a" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "public_route_association_b" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_b.id
}

resource "aws_route_table_association" "private_route_association_a" {
  route_table_id = aws_route_table.private_route_table_a.id
  subnet_id      = aws_subnet.private_a.id
}

resource "aws_route_table_association" "private_route_association_b" {
  route_table_id = aws_route_table.private_route_table_b.id
  subnet_id      = aws_subnet.private_b.id
}

resource "aws_nat_gateway" "nat_a" {
  subnet_id         = aws_subnet.public_a.id
  connectivity_type = "public"
  allocation_id = aws_eip.eip_a.id
  tags = {
    Name = "nat_a"
  }
}

resource "aws_nat_gateway" "nat_b" {
  subnet_id         = aws_subnet.public_b.id
  allocation_id = aws_eip.eip_b.id
  connectivity_type = "public"
  tags = {
    Name = "nat_b"
  }
}

resource "aws_eip" "eip_a" {}

resource "aws_eip" "eip_b" {}

resource "aws_iam_role" "terraform_private_role" {
  name = "terraform_private_role"
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

resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.terraform_private_role.name
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