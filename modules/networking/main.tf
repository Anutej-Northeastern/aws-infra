#code to create a vpc
resource "aws_vpc" "my_vpc" {

  cidr_block           = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name = "VPC_Terraform"
  }
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
