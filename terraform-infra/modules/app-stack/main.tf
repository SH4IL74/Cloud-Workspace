# 1.Create S3 Bucket
resource "aws_s3_bucket" "app_storage"{
  bucket = "${var.project_name}-storage-${var.environment}"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 2.Create DynamoDB Table (NoSQL)
resource "aws_dynamodb_table" "users_table"{
  name         = "${var.project_name}-users-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"

  attribute{
    name = "UserId"
    type = "S" # String
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 1.Custom Virtual Private Cloud
resource "aws_vpc" "main_vpc"{
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc-${var.environment}"
    Environment = var.environment
  }
}

# 2.Public Subnet inside the VPC 
resource "aws_subnet" "public_subnet"{
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-${var.environment}"
    Environment = var.environment
  }
}
# 3.Security Group (Firewall Rules)
resource "aws_security_group" "web_sg"{
  name        = "${var.project_name}-web-sg-${var.environment}"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main_vpc.id

  # Inbound Rule: Allow HTTP (Port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rule: Allow all outbound traffic
  egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-web-sg-${var.environment}"
    Environment = var.environment
  }
}

# 1.Zip the python code automatically before applying
data "archive_file" "lambda_zip"{
  type        = "zip"
  source_file = "${path.module}/app.py"
  output_path = "${path.module}/lambda_function.zip"
}

# 2.IAM Role for Lambda 
resource "aws_iam_role" "lambda_role"{
  name = "${var.project_name}-lambda-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com" 
        }
      }
    ]
  })
}

# 3.AWS Lambda Function Resource 
resource "aws_lambda_function" "app_lambda"{
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-function-${var.environment}"
  role             = aws_iam_role.lambda_role.arn 
  handler          = "app.handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

