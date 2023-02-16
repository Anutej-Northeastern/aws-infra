
module "vpc_1" {
  source = "./modules/networking"
  /*
    then mention all the variables that you'll be using in this module
    */
  cidr                   = var.cidr
  igw_cidr               = var.igw_cidr
  private_cidrs          = var.private_cidrs
  public_cidrs           = var.public_cidrs
  aws_availability_zones = var.aws_availability_zones
}
module "vpc_2" {
  source = "./modules/networking"
  /*
    then mention all the variables that you'll be using in this module
    */
  cidr                   = "192.168.0.0/16"
  igw_cidr               = "0.0.0.0/0"
  private_cidrs          = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  public_cidrs           = ["192.168.10.0/24", "192.168.11.0/24", "192.168.12.0/24"]
  aws_availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
}