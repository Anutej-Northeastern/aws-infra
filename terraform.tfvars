region = "us-east-1"

cidr          = "10.1.0.0/16"
igw_cidr      = "0.0.0.0/0"
public_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_cidrs = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

aws_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

ami_id   = "ami-0eb93d0e82ee6dff9"
key_pair = "Ec2"

db_name     = "csye6225"
db_username = "csye6225"
db_password = "p0stgres987"

policyARN = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

profile     = "prod"                                                                                # Demo Profile
zone_id     = "Z00013201MESJB4SQS7CO"                                                               #Demo zone Id
domain_name = "prod.apoddaturi.me"                                                                  #Demo Domain name
cert_arn    = "arn:aws:acm:us-east-1:778516090662:certificate/ceb8fc02-153d-443f-9e77-070f2f775c88" # Demo Certificate ARN
# cert_arn    = "arn:aws:acm:us-east-1:778516090662:certificate/c3317376-aa3e-4d4b-a4ca-1c7ba3d62d4f" # Demo Certificate Arn

# profile     = "dev"                   # Dev Profile
# zone_id     = "Z08796222T9PRBMNUKUNX" #Dev zone Id
# domain_name = "dev.apoddaturi.me"     #Dev Domain name
# cert_arn = "arn:aws:acm:us-east-1:381467478370:certificate/ea2f437d-a2f9-45c3-bdce-b9caecc17faf" # Dev Certificate Arn