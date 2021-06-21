







# resource "aws_nat_gateway" "nat_a" {
#   subnet_id         = aws_subnet.public_a.id
#   connectivity_type = "public"
#   allocation_id     = aws_eip.eip_a.id
#   tags = {
#     Name = "nat_a"
#   }
# }

# resource "aws_nat_gateway" "nat_b" {
#   subnet_id         = aws_subnet.public_b.id
#   allocation_id     = aws_eip.eip_b.id
#   connectivity_type = "public"
#   tags = {
#     Name = "nat_b"
#   }
# }

# resource "aws_eip" "eip_a" {}

# resource "aws_eip" "eip_b" {}


