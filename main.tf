terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.46.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_vpc" "terraform_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "terraform-vpc"
    }
}

resource "aws_subnet" "public_a" {
    vpc_id = aws_vpc.terraform_vpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.0.0/24"
    tags = {
        "Name" = "PublicA"
    }
    map_public_ip_on_launch = true
}

resource "aws_subnet" "public_b" {
    vpc_id = aws_vpc.terraform_vpc.id
    availability_zone = "us-east-1b"
    cidr_block = "10.0.1.0/24"
    tags = {
        "Name" = "PublicB"
    }
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private_a" {
    vpc_id = aws_vpc.terraform_vpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.16.0/20"
    tags = {
        "Name" = "PrivateA"
    }
}

resource "aws_subnet" "private_b" {
    vpc_id = aws_vpc.terraform_vpc.id
    availability_zone = "us-east-1b"
    cidr_block = "10.0.32.0/20"
    tags = {
        "Name" = "PrivateB"
    }
}

resource "aws_instance" "terraform_instance" {
    ami = "ami-0aeeebd8d2ab47354"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.private_a.id
    security_groups = [aws_security_group.ssh.id]
    tags = {
        Name = "terraform_instance"
    }
}

resource "aws_security_group" "ssh" {
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.terraform_vpc.cidr_block]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_ssh"
  }
}
