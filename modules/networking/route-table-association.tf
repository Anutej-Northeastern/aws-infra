#code to create subnet route table association for public subnet
/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_cidrs)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
