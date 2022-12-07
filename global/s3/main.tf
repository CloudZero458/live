provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  lifecycle {
    # prevent accidental deletion. if you want to delete, just comment out this setting out
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  #enables version for the state files

  # references the terraform s3 bucket resource and the S3 bucket name

  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {

  # references the terraform s3 bucket resource and the S3 bucket name
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  # blocks all public access to the state files. buckets are private by default but can be made public. this prevents that

  # references the terraform s3 bucket resource and the S3 bucket name
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  # creates a dynamodb table that locks the state file when somebody is working on it
  name = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
