variable "ssh_key" {
  type = string
}

variable "ami_val" {
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets_ids" {
  description = "The ID of the VPC"
  type        = list(string)
}