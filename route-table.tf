
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

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat_a.id
  # }

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.s3.id
  }

  tags = {
    Name = "private_route_table_a"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.terraform_vpc.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat_b.id
  # }

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