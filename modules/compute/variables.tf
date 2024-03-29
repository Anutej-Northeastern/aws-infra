
variable "ami_id" {
  type    = string
  default = "ami-0dfcb1ef8550277af"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "private_subnets_ids" {
  type = list(string)

}

variable "key_pair" {

  type    = string
  default = "Ec2"
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "region" {
  type = string
}

variable "ec2_iam_role" {
  description = "The name of the IAM role"
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "cert_arn" {
  type = string
}