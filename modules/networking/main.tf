#code to create a vpc
resource "aws_vpc" "my_vpc" {

  cidr_block = var.cidr
  tags = {
    Name = "VPC_Terraform"
  }
}


resource "aws_security_group" "sg" {
  name_prefix = "app-"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "https"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPRuVxAG7AccT7g8ne5HsDxZwcV8YXPddnJSKQJsLkQG0xEFWfWVGdHmoWGgI5b2WrZAHgpBStteDuD3d/iOr7qhB6efAEMh27Y1wDbhR862nbNmYRhsEqD87S9IeLaIDVUq3sYqrQFp7QtG7cKLSDbZaf8ZHHZwxpc5phxJtBC4tz6KZgPuxQevl/nIh9hWuxoMoOWmoVBGfFzHLoncmMeg1FVYqKKc/sseGhopWuwe3YzzE19pUcNa+xjJDBjcoHW1vYVoKKQN7/GzZvrwEx7qILIC0zF3uuTby0kT7DSjwt7BXBieMdogvSrsfL7mtZI1Ls8Mx8jrkyfKPxmeMr8aZAhJgha+nL6RCXEbNDlamtxZb8rI/Od2wNhi1XTOx/jB+Bvr01cwUkSJsSo6EDL5Bux5RTEWRBn1pQUfP/54WzaOIlDKM245iglzzUxB0g0MiU+31xXGskcvh/GGctULKd5XpOZjKM4jGbA4WijfZ/owOIj9bfhfADuAqYuTk= podda@Anutej-XPS-15"
}

resource "aws_instance" "example" {
  ami                    = "ami-059d46e63623bc0df"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = element(aws_subnet.public_subnet.*.id, 0)
  key_name               = aws_key_pair.deployer.key_name
  root_block_device {
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = true
  }
  disable_api_termination = true
}
