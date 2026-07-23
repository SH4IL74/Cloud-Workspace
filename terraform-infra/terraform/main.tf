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