#code to create a public subnet
resource "aws_subnet" "public_subnet" {

  vpc_id = aws_vpc.my_vpc.id        #specifying to which vpc this public subnet belongs to
  count  = length(var.public_cidrs) #get the count of number of public subnet cidrs you gave
  #az_count = "${length(data.aws_availability_zones.available.names)}" #get the count of number of availability zones present in the region you are operating in

  cidr_block              = var.public_cidrs[count.index]                                                  #setting the cidr_block for this public subnet dynamically
  availability_zone       = var.aws_availability_zones[count.index % (length(var.aws_availability_zones))] #setting the availability_zone for this public subnet dynamically
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet - ${var.public_cidrs[count.index]} - ${var.aws_availability_zones[count.index % (length(var.aws_availability_zones))]}"
  }
}

#code to create a private subnet
resource "aws_subnet" "private_subnet" {

  vpc_id = aws_vpc.my_vpc.id         #specifying to which vpc this private subnet belongs to
  count  = length(var.private_cidrs) #get the count of number of private subnet cidrs you gave
  #az_count = "${length(data.aws_availability_zones.available.names)}" #get the count of number of availability zones present in the region you are operating in

  cidr_block              = var.private_cidrs[count.index]                                                 #setting the cidr_block for this private subnet dynamically
  availability_zone       = var.aws_availability_zones[count.index % (length(var.aws_availability_zones))] #setting the availability_zone for this private subnet dynamically
  map_public_ip_on_launch = true
  tags = {
    Name = "Private_Subnet - ${var.private_cidrs[count.index]} - ${var.aws_availability_zones[count.index % (length(var.aws_availability_zones))]}"
  }
}

output "public_subnets_ids" {
  value = aws_subnet.public_subnet.*.id
}
output "private_subnets_ids" {
  value = aws_subnet.private_subnet.*.id
}
