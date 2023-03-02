
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

# module "my-ec2" {
#   source    = "./modules/ec2"
#   vpc_id    = module.my-network.vpc_id
#   subnet_id = module.my-network.subnet_id
# }

module "my_s3" {
  source = "./modules/s3"
}

module "my-ec2" {
  region              = var.region
  source              = "./modules/ec2"
  ami_id              = var.ami_id
  key_pair            = var.key_pair
  vpc_id              = module.my-network.vpc_id
  subnet_id           = module.my-network.subnet_id
  private_subnets_ids = module.my-network.private_subnets_ids
  db_username         = var.db_username
  db_password         = var.db_password
  db_name             = var.db_name
  ec2_iam_role        = module.my_s3.IAM_role
  bucket_name         = module.my_s3.s3_bucket_name

}
