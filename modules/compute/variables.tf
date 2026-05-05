variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "asg_min_size" { type = number }
variable "asg_max_size" { type = number }
variable "asg_desired_capacity" { type = number }
variable "iam_instance_profile" { type = string }
variable "s3_bucket_name" { type = string }
variable "db_endpoint" {
  type      = string
  sensitive = true
}