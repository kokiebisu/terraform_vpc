resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket
    acl = "private"

    tags = {
        Name = "terraform-bucket"
    }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.terraform_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    Name = "s3-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "connect" {
    route_table_id = aws_route_table.private_route_table.id
    vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

variable "bucket" {
    type = string
    default = "terraform-bucket-140819"
}

