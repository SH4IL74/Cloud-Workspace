# Creating a S3 bucket 
resource "aws_s3_bucket" "my_s3_bucket"{
    bucket = "${var.project_name}-storage-${var.environment}"

    tags = {
        Environment = var.environment
        ManagedBy   = "terraform"
    }
} 

# Creating a DynamoDB Table
resource "aws_dynamodb_table" "my_dynamodb_table"{
    name         = "${var.project_name}-users-${var.environment}"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "UserId"

    attribute {
        name = "UserId"
        type = "S" #String
    }

    tags = {
        Environment = var.environment
        ManagedBy   = "Terraform"
    }
}

# Creating a VPC 
resource "aws_vpc" "main_vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
        Name        = "${var.project_name}-vpc-${var.environment}"
        Environment = var.environment
    }
}

# Creating a public subnet for VPC
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = var.public_subnet_cidr
    map_public_ip_on_launch = true 

    tags = {
        Name        = "${var.project_name}-public-subnet-${var.environment}"
        Environment = var.environment
    }
}