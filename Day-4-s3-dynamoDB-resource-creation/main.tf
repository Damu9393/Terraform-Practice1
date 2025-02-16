# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Create S3 Bucket for Terraform State Storage
resource "aws_s3_bucket" "terraform_state" {
  bucket = "innovasolutionsstatefile93"  # Ensure the name is globally unique

  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion
  }
}

# Enable Versioning on the S3 Bucket (Best practice for Terraform state)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server-Side Encryption for Security
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create DynamoDB Table for Terraform State Locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock-dynamo"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"  # Better for cost efficiency

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Configure Terraform Backend to use S3 and DynamoDB for State Management
terraform {
  backend "s3" {
    bucket         = "innovasolutionsstatefile93"  # Must match the S3 bucket name
    key            = "terraform.tfstate"         # Define the state file path
    region         = "us-east-1"                 # Should match the provider region
    encrypt        = true                        # Encrypt state file for security
    dynamodb_table = "terraform-state-lock-dynamo"  # Enables state locking
  }
}
