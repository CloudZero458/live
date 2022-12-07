variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique"
  type = string
}

variable "table_name" {
  description = "the name of the DynamoDB table. Must be unique"
  type = string
}
