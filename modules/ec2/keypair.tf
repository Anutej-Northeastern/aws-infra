resource "aws_key_pair" "deployer" {
  key_name   = "ec2_dev-${timestamp()}"
  public_key = var.ssh_key
}