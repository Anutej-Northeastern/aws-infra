#code to create a public subnet
resource "aws_subnet" "public_subnet" {

  vpc_id = aws_vpc.my_vpc.id
  count  = length(var.public_cidrs)

  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = var.aws_availability_zones[count.index % (length(var.aws_availability_zones))]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet - ${var.public_cidrs[count.index]} - ${var.aws_availability_zones[count.index % (length(var.aws_availability_zones))]}"
  }
}

#code to create a private subnet
resource "aws_subnet" "private_subnet" {

  vpc_id                  = aws_vpc.my_vpc.id
  count                   = length(var.private_cidrs)
  cidr_block              = var.private_cidrs[count.index]
  availability_zone       = var.aws_availability_zones[count.index % (length(var.aws_availability_zones))]
  map_public_ip_on_launch = true
  tags = {
    Name = "private_subnet - ${var.private_cidrs[count.index]} - ${var.aws_availability_zones[count.index % (length(var.aws_availability_zones))]}"
  }
}