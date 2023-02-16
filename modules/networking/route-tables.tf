#code to create a route table for public subnet
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "public_route_table"
  }
}

#code to create a route table for private subnet
resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private_route_table"
  }
}