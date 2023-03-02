#database security group
resource "aws_security_group" "database" {
  name        = "database"
  description = "Security group for RDS instance for database"
  vpc_id      = var.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = "5432"
    to_port         = "5432"
    security_groups = [aws_security_group.sg.id]
  }

  tags = {
    "Name" = "database-sg"
  }
}

#RDS parameter group
resource "aws_db_parameter_group" "my_rds_pg" {
  name        = "my-db-pg"
  family      = "postgres14"
  description = "Custom RDS parameter group for postgres 13 database"
  #   parameter {
  #     name  = "character_set_server"
  #     value = "utf8"
  #   }
}


#RDS instance
resource "aws_db_instance" "my_rds_instance" {
  identifier                = "csye6225"
  engine                    = "postgres"
  engine_version            = "14.1"
  instance_class            = "db.t3.micro"
  db_name                   = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  parameter_group_name      = aws_db_parameter_group.my_rds_pg.name
  vpc_security_group_ids    = [aws_security_group.database.id]
  allocated_storage         = 20
  storage_type              = "gp2"
  multi_az                  = false
  final_snapshot_identifier = "final-snapshot"
  publicly_accessible       = true
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  tags = {
    Name = "db_instance"
  }
}


#security group to my ec2 instance
resource "aws_security_group" "sg" {

  name_prefix = "app-sg"
  vpc_id      = var.vpc_id

  #inbound rule for ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #inbound rules for http
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #inbound rules for https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #inbound rules for my app
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#RDS subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db_subnet_group"
  description = "RDS subnet group for database"
  subnet_ids  = var.private_subnets_ids
  tags = {
    Name = "db_subnet_group"
  }
}



#creating a new ec2 instance
resource "aws_instance" "my_ec2" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = var.subnet_id
  key_name               = var.key_pair
  root_block_device {
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = true
  }
  disable_api_termination = true

  #   code for the user data
  user_data = <<EOF

#!/bin/bash

echo "export DB_USER=${var.db_username} " >> /home/ec2-user/webapp/.env
echo "export DB_PASSWORD=${var.db_password} " >> /home/ec2-user/webapp/.env
echo "export DB_HOST=${aws_db_instance.my_rds_instance.endpoint} " >> /home/ec2-user/webapp/.env
echo "export DB_NAME=${var.db_name} " >> /home/ec2-user/webapp/.env
echo "export S3_BUCKET=${var.bucket_name} " >> /home/ec2-user/webapp/.env
echo "export S3_REGION=${var.region} " >> /home/ec2-user/webapp/.env
sudo chmod +x setenv.sh
sh setenv.sh

 EOF
  tags = {
    "Name" = "Ec2_Terraform-${timestamp()}"
  }
}

#attach iam role to ec2 instance
resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "app_instance_profile"
  role = var.ec2_iam_role
}

# output "app-sg_id" {
#   value = aws_security_group.sg.Id
# }

output "database_name" {
  value = aws_db_instance.my_rds_instance.db_name
}


output "database_username" {
  value = aws_db_instance.my_rds_instance.username
}


output "database_password" {
  value = aws_db_instance.my_rds_instance.password
}


output "database_endpoint" {
  value = aws_db_instance.my_rds_instance.endpoint
}

