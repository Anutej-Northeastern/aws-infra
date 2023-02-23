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

variable "ssh_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPRuVxAG7AccT7g8ne5HsDxZwcV8YXPddnJSKQJsLkQG0xEFWfWVGdHmoWGgI5b2WrZAHgpBStteDuD3d/iOr7qhB6efAEMh27Y1wDbhR862nbNmYRhsEqD87S9IeLaIDVUq3sYqrQFp7QtG7cKLSDbZaf8ZHHZwxpc5phxJtBC4tz6KZgPuxQevl/nIh9hWuxoMoOWmoVBGfFzHLoncmMeg1FVYqKKc/sseGhopWuwe3YzzE19pUcNa+xjJDBjcoHW1vYVoKKQN7/GzZvrwEx7qILIC0zF3uuTby0kT7DSjwt7BXBieMdogvSrsfL7mtZI1Ls8Mx8jrkyfKPxmeMr8aZAhJgha+nL6RCXEbNDlamtxZb8rI/Od2wNhi1XTOx/jB+Bvr01cwUkSJsSo6EDL5Bux5RTEWRBn1pQUfP/54WzaOIlDKM245iglzzUxB0g0MiU+31xXGskcvh/GGctULKd5XpOZjKM4jGbA4WijfZ/owOIj9bfhfADuAqYuTk= podda@Anutej-XPS-15"
}

variable "ami_val" {
  type    = string
  default = "ami-0d7cd1bbaf231102c"
}

