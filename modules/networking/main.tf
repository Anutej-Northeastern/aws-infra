#code to create a vpc
resource "aws_vpc" "my_vpc" {

  cidr_block = var.cidr
  tags = {
    Name = "VPC_Terraform"
  }
}


resource "aws_security_group" "sg" {
  name_prefix = "app-sg"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "application_security_group"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2_dev1"
  public_key = var.ssh_key
}

resource "aws_instance" "example" {
  ami                     = "ami-071b0fc939ab10537"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.sg.id]
  subnet_id               = element(aws_subnet.public_subnet.*.id, 0)
  key_name                = aws_key_pair.deployer.key_name
  disable_api_termination = false
  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    "Name" = "Ec2_Terraform-{{timestamp}}"
  }
}
