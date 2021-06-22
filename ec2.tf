resource "aws_instance" "terraform_public_instance" {
  ami                         = var.public_instance
  instance_type               = var.instance_size
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.public.id]
  tags = {
    Name = "terraform_public_instance"
  }
  key_name = aws_key_pair.connector.key_name
}


resource "aws_instance" "terraform_private_instance" {
  ami             = var.private_instance
  instance_type   = var.instance_size
  subnet_id       = aws_subnet.private.id
  security_groups = [aws_security_group.private.id]
  tags = {
    Name = "terraform_private_instance"
  }
  iam_instance_profile = aws_iam_instance_profile.terraform_ec2_instance_profile.name
  key_name             = aws_key_pair.inner_connector.key_name
}


resource "aws_key_pair" "connector" {
  key_name   = "connector"
  public_key = var.connector_public_key
}

resource "aws_key_pair" "inner_connector" {
  key_name   = "inner_connector"
  public_key = var.connector_inner_public_key
}


variable "public_instance" {
  type = string
  default = "ami-0aeeebd8d2ab47354"
}

variable "private_instance" {
  type = string
  default = "ami-0aeeebd8d2ab47354"
}

variable "instance_size" {
  type = string
  default = "t2.micro"
}


variable "connector_public_key" {
  type        = string
  description = "public key to connect"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdNOZiReUSDCQcVCvDaKqeUW83adcj+zuHk6r1fX2nR1bSxWLzbItJ1nKbmZzXap9SWUPhSsgxfTEBXkhQYMl0c7qiJGrybyHjBwztmDK78utBmp4E/GKNoP7my/jW6ly+Vrn8s7ny94aq4Uzk/OV5REnHkFozd9y9mXtoyCLblgGjMkKIOx48wh4yRvb8yHyviXUHbRw/kNbjfgZqcD5dzcP6nezq2uFI65wEHU8YEeoL4jbARVRJwoMEaVMa0tnOb485d9q7nHVz+T4YYmpMUbeQhwAtDN5/Wazsrr+fhM9Z19rB07yhFoYq4Iue+3m0dUUfok/aWIV4Kjwu80Hn"
}

variable "connector_inner_public_key" {
  type        = string
  description = "public key to inner connector"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCi2N7hT7gpzLniY1Pq9PEiWaNwPNOHpHiYqhd1inz2l7q58KUzacmklYctpGyxgvnJa2w2F299ccQJSwsLb7fi3gt326X+y/pUp78ZE+EYezACkhqrHhSUYfjBo3WHZLZpDjhD88OZg38Ru2moRhh3qpqrppZO8q9jzgawPIvP40ErX6xgp4v0X1jp0heFPglg1URVYOUaASsOvopJfoIl3LXm0kbOKpPFw3C/91z5+k7wKtYIIU9lqjrq1/Glt0PIEd4a8pf8fVYOHQGziccCd09RBQQqVElsqmKEsHbVazUQ0kVWefJBW2dG/bec8ctLdHxVtfwzbEZCSHhq3CUF"
}
