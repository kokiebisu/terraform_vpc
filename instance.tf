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


resource "aws_instance" "terraform_private_instance" {
  ami             = "ami-0aeeebd8d2ab47354"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_a.id
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