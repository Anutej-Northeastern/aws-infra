#code to create a vpc
resource "aws_vpc" "my_vpc" {

  cidr_block = var.cidr
  tags = {
    Name = "VPC_Terraform"
  }
}

output "vpcid" {
  value = aws_vpc.my_vpc.id
  description = "VPC Id"
  sensitive = false
}
