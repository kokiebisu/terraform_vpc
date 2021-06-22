######## RESOURCES

resource "aws_vpc" "terraform_vpc" {
  cidr_block          = "10.0.0.0/16"
  instance_tenancy    = "default"
  enable_dns_support  = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name = "terraform-vpc"
  }
}


######## VARIABLES

variable "dns_support" {
  type    = bool
  default = true
}

variable "dns_hostnames" {
  type    = bool
  default = true
}