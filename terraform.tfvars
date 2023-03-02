region        = "us-east-1"
profile       = "prod"
cidr          = "10.1.0.0/16"
igw_cidr      = "0.0.0.0/0"
public_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_cidrs = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

aws_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

ami_id   = "ami-0bcd3b8094454ed62"
key_pair = "Ec2"

db_name     = "csye6225"
db_username = "csye6225"
db_password = "p0stgres987"

