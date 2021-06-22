# Public Subnet for instances with access to the internet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  availability_zone       = var.availability_zone
  cidr_block              = var.subnet_cidr_block_public
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet"
  }

}

# Private Subnet for instances with no access to the internet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  availability_zone       = var.availability_zone
  cidr_block              = var.subnet_cidr_block_private
  map_public_ip_on_launch = false
  tags = {
    "Name" = "public-subnet"
  }

}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "subnet_cidr_block_public" {
  type    = string
  default = "10.0.0.0/24"
}

variable "subnet_cidr_block_private" {
  type    = string
  default = "10.0.1.0/24"
}