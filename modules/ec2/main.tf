resource "aws_instance" "example" {
  ami                     = var.ami_val
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.sg.id]
  subnet_id               = var.public_subnets_ids[0]
  key_name                = var.ssh_key
  disable_api_termination = true

  root_block_device {
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = false
  }
  tags = {
    "Name" = "Ec2_Terraform-${timestamp()}"
  }

}