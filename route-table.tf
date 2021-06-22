resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform-public-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-private-table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route_table_association" "private_route_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_vpc_endpoint_route_table_association" "association" {
  route_table_id = aws_route_table.private_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}