resource "random_id" "randm" {
  byte_length = 4
}

#load balancer security group
resource "aws_security_group" "loadBalancer" {
  name        = "load balancer"
  description = "Security group for load balancer to access instances"
  vpc_id      = var.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "load balancer"
  }
}

#security group to my ec2 instance
resource "aws_security_group" "sg" {
  name_prefix = "app-sg"
  description = "Security group for web application instances"
  vpc_id      = var.vpc_id
  #inbound rule for ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #inbound rules for my app
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.loadBalancer.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "application"
  }

}

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
    "Name" = "database"
  }
}

#RDS subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db-subnet-group-${random_id.randm.hex}"
  description = "RDS subnet group for database"
  subnet_ids  = var.private_subnets_ids
  tags = {
    Name = "db_subnet_group"
  }
}

#RDS parameter group
resource "aws_db_parameter_group" "my_rds_pg" {
  name        = "my-db-pg-${random_id.randm.hex}"
  family      = "postgres14"
  description = "Custom RDS parameter group for postgres 13 database"
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "rds_security_key" {
  description             = "KMS key for RDS instance"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy = jsonencode({
    "Id" : "key-consolepolicy-3",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "Service" = "rds.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "Service" = "rds.amazonaws.com"
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
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
  skip_final_snapshot       = true
  final_snapshot_identifier = "final-snapshot"
  publicly_accessible       = false
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  storage_encrypted      = true
  kms_key_id                = aws_kms_key.rds_security_key.arn
  tags = {
    Name = "db_instance"
  }
}


resource "aws_kms_key" "ebs_security_key" {
  description             = "My customer managed key"
  enable_key_rotation     = true
  deletion_window_in_days = 10
  policy = jsonencode({
    "Id" : "key-consolepolicy-3",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
          ]
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
          ]
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
  tags = {
    "Name" = "ec2-key"
  }
}

# creating userdata resource
data "template_file" "user_data" {
  template = <<EOF
  #!/bin/bash
  touch .env
  echo "\n"
  echo "DB_USER=${var.db_username}" >> /home/ec2-user/webapp/.env
  echo "DB_PASSWORD=${var.db_password}" >> /home/ec2-user/webapp/.env
  echo "DB_HOST=${aws_db_instance.my_rds_instance.endpoint}" >> /home/ec2-user/webapp/.env
  echo "DB_NAME=${var.db_name}" >> /home/ec2-user/webapp/.env
  echo "S3_BUCKET=${var.bucket_name}" >> /home/ec2-user/webapp/.env
  echo "S3_REGION=${var.region}" >> /home/ec2-user/webapp/.env
  EOF
}

# Resource to create Ec2 launch template
resource "aws_launch_template" "ec2" {
  name          = "asg_launch_config"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_pair
  user_data     = base64encode(data.template_file.user_data.template)
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 50
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.ebs_security_key.arn
    }
  }
  network_interfaces {
    security_groups             = [aws_security_group.sg.id]
    associate_public_ip_address = true
    subnet_id                   = element(var.subnet_ids, 1)
  }
  # disable_api_termination = false
  iam_instance_profile {
    name = aws_iam_instance_profile.app_instance_profile.name
  }
  tags = {
    "Name" = "Ec2_Terraform_${timestamp()}"
  }
}

# Creating auto scaling group resource
resource "aws_autoscaling_group" "asg" {
  name = "csye6225-asg-spring2023" ##asg_launch_config
  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }
  health_check_type   = "EC2"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  default_cooldown    = 60
  vpc_zone_identifier = var.subnet_ids ###New Parameter
  ## AvailabilityZones and subnets to know where to create ec2 instances
  enabled_metrics     = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  metrics_granularity = "1Minute"
  tag {
    key                 = "webapp"
    value               = "webapp_instance"
    propagate_at_launch = true
  }
  target_group_arns = [aws_lb_target_group.alb_tg.arn]
}

# Scaling up and Scaling Down Policies

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-alarm"
  alarm_description   = "Scale Up Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "2"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.scale_up.arn}"]
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "asg-ec2-scale-up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "60"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale-down-alarm"
  alarm_description   = "Scale Down Alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "4"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "3"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.scale_down.arn}"]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "asg-ec2-scale-down"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "60"
}


# Resource to create load balance and attach it to the asg
resource "aws_lb" "lb" {
  name               = "csye6225-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadBalancer.id]
  subnets            = [for subnet in var.subnet_ids : subnet]
  tags = {
    Application = "WebApp"
  }
}

# Resource for load balancer to send requests to a target group
resource "aws_lb_target_group" "alb_tg" {
  name        = "csye6225-lb-alb-tg"
  target_type = "instance"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    enabled             = true
    path                = "/healthz"
    port                = 3000
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# Listender resource to listen for load balancer
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

}

resource "aws_lb_listener_certificate" "certificate_attach" {
  listener_arn    = aws_lb_listener.front_end.arn
  certificate_arn = var.cert_arn
}

#attach iam role to ec2 instance
resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "app_instance_profile-${random_id.randm.hex}"
  role = var.ec2_iam_role
}

# Inserting A record in the route53 hosted Zone
resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}


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


