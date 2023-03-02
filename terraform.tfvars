region                 = "us-east-1"
profile                = "dev"
cidr                   = "10.0.0.0/16"
igw_cidr               = "0.0.0.0/0"
public_cidrs           = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_cidrs          = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
aws_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

ami_id   = "ami-03dac0aca2881a6b7"
key_pair = "ec2"

db_name     = "csye6225"
db_username = "csye6225"
db_password = "p0stgre$987"