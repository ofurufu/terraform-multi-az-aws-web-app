variable "aws_region" {
  type = string
}

variable "project_name" {
  description = "Short name used to prefix all resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging or, prod"

  }
  type = string
}

variable "owner" {
  description = "Owner name for tagging (e.g. your name or team)"
  type        = string
}