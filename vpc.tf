######## RESOURCES


# Creates the VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block          = "10.0.0.0/16"
  instance_tenancy    = false
  enable_dns_support  = var.dns_support
  enable_dns_hostname = var.dns_hostname

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.terraform_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    Name = "s3-endpoint"
  }
}

######## VARIABLES

variable "dns_support" {
  type    = bool
  default = true
}

variable "dns_hostname" {
  type    = bool
  default = true
}