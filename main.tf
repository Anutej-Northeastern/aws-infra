module "my-network" {

  #mention the folder where your module is
  source = "./modules/networking"

  #then mention all the variables that you'll be using in this module
  cidr                   = var.cidr
  igw_cidr               = var.igw_cidr
  private_cidrs          = var.private_cidrs
  public_cidrs           = var.public_cidrs
  aws_availability_zones = var.aws_availability_zones

}

module "my_s3" {
  source    = "./modules/s3"
  policyARN = var.policyARN
}

module "my-ec2" {
  region              = var.region
  source              = "./modules/compute"
  ami_id              = var.ami_id
  key_pair            = var.key_pair
  vpc_id              = module.my-network.vpc_id
  subnet_id           = module.my-network.subnet_id
  subnet_ids          = module.my-network.subnet_ids
  private_subnets_ids = module.my-network.private_subnets_ids
  db_username         = var.db_username
  db_password         = var.db_password
  db_name             = var.db_name
  ec2_iam_role        = module.my_s3.IAM_role
  bucket_name         = module.my_s3.s3_bucket_name
  zone_id             = var.zone_id
  domain_name         = var.domain_name
  cert_arn            = var.cert_arn
}
