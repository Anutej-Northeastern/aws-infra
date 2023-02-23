region                 = "us-east-2"
profile                = "dev"
cidr                   = "10.0.0.0/16"
igw_cidr               = "0.0.0.0/0"
public_cidrs           = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_cidrs          = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
aws_availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]