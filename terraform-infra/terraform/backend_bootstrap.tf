# S3 Bucket to hold state files 
resource "aws_s3_bucket" "tf_state_bucket"{
    bucket        = "cloud-app-tf-state-store"
    force_destroy = true
}

# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "tf_state_locks"{
    name         = "cloud-app-tf-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute{
        name = "LockID"
        type = "S"
    }
}