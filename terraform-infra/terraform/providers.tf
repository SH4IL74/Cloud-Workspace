terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

# Migrate state storage to the newly created S3 bucket
backend "s3" {
  bucket = "cloud-app-tf-state-store"
  key = "global/s3/terraform.tfstate"
  region = "ap-south-1"
  dynamodb_table = "cloud-app-tf-locks"
  encrypt = true
  }
}
 

provider "aws" {
  region                      = "ap-south-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}