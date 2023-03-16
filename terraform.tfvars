region = "us-east-1"

cidr          = "10.1.0.0/16"
igw_cidr      = "0.0.0.0/0"
public_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_cidrs = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

aws_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

ami_id   = "ami-075a778a5a4281409"
key_pair = "Ec2"

db_name     = "csye6225"
db_username = "csye6225"
db_password = "p0stgres987"

profile     = "prod"                  # Demo Profile
zone_id     = "Z00013201MESJB4SQS7CO" #Demo zone Id
domain_name = "prod.apoddaturi.me"    #Demo Domain name

# profile     = "dev"                   # Dev Profile
# zone_id     = "Z08796222T9PRBMNUKUNX" #Dev zone Id
# domain_name = "dev.apoddaturi.me"     #Dev Domain name
