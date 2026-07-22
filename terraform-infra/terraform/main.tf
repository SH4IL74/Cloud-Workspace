terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Standard AWS provider setup — tflocal automatically intercepts endpoints
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# Create a test S3 Bucket
resource "aws_s3_bucket" "demo" {
  bucket = "my-local-bucket"
}