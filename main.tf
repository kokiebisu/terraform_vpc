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
    ami = "ami-0b683223eeade51eb"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.private_a.id
}

resource "aws_security_group_rule" "terraform_security" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_subnet.public_a.id
}

resource "aws_key_pair" "deployer" {
    key_name = var.aws_ec2_key_name
    public_key = var.aws_ec2_public_key
}