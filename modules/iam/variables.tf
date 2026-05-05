variable "name_prefix" {
  type = string
}
variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket the EC2 role should access"
}