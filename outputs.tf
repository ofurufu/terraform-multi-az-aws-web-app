output "alb_dns_name" {
  description = "Public DNS of the Application Load Balancer — open this in your browser"
  value       = module.compute.alb_dns_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "rds_endpoint" {
  description = "RDS connection endpoint (private, only reachable from EC2s)"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "s3_bucket_name" {
  description = "Name of the S3 assets bucket"
  value       = module.storage.bucket_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.compute.asg_name
}