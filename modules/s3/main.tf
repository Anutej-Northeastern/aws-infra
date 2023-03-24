resource "random_id" "rand" {
  byte_length = 4
}
resource "aws_s3_bucket" "my_s3" {

  #random bucket name
  bucket        = "my-s3-${random_id.rand.hex}"
  acl           = "private"
  force_destroy = true


  #Create a lifecycle policy for the bucket to transition objects from STANDARD storage class to STANDARD_IA storage class after 30 days.
  lifecycle_rule {
    id      = "Storage_class_transition"
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  #default encryption for S3 Buckets
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#IAM policy for ec2 to access the s3 bucket
resource "aws_iam_policy" "my_WebAppS3_policy" {
  name = "WebAppS3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjects"
        ]
        Resource = "arn:aws:s3:::${aws_s3_bucket.my_s3.bucket}/*"
        Resource = "arn:aws:s3:::${aws_s3_bucket.my_s3.bucket}/*"
      }
    ]
  })
}

#IAM role for ec2 to access the s3 bucket
resource "aws_iam_role" "WebAppS3_role" {
  name = "EC2-CSYE6225"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

#IAM role policy attachment
resource "aws_iam_role_policy_attachment" "WebAppS3_role_policy_attachment" {
  role       = aws_iam_role.WebAppS3_role.name
  policy_arn = aws_iam_policy.my_WebAppS3_policy.arn
}

resource "aws_iam_role_policy_attachment" "CloudwatchPolicy" {
  role       = aws_iam_role.WebAppS3_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_s3.bucket
}

output "IAM_role" {
  value = aws_iam_role.WebAppS3_role.name
}