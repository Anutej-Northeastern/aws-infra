#code to create a route table for public subnet
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Public_RouteTable_Terraform"
  }
}

#code to create a route table for private subnet
resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Private_RouteTable_Terraform"
  }
}