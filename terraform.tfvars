region                 = "us-east-1"
profile                = "dev"
cidr                   = "10.0.0.0/16"
igw_cidr               = "0.0.0.0/0"
public_cidrs           = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_cidrs          = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
aws_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]


ami_val                = "ami-0dfcb1ef8550277af"
ssh_key                = "Ec2" //Name of the Ec2 Key uploaded in the account