/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "IGW_Terraform"
  }
}