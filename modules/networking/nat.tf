# /* NAT */
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.NAT_eip.id
#   subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
#   depends_on    = [aws_internet_gateway.ig]
#   tags = {
#     Name = "NAT_Terraform"
#   }
# }