variable "cidr" {
  type = string
}

variable "igw_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(string)
}

variable "private_cidrs" {
  type = list(string)
}


variable "aws_availability_zones" {
  type = list(string)
}
