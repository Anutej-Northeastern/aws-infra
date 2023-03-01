
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

module "Ec2_intstance" {
  source             = "./modules/ec2"
  ami_val            = var.ami_val
  ssh_key            = var.ssh_key
  vpc_id             = module.vpc_1.vpc_id
  public_subnets_ids = module.vpc_1.public_subnets_ids
  # private_subnets_ids = module.networkingmy1.private_subnets_ids
}