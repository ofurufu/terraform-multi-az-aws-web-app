# terraform-multi-az-aws-web-app


# 🏗️ Terraform Multi-AZ AWS Web Application

A production-grade infrastructure project built with **Terraform**, demonstrating 
real-world cloud engineering patterns used in enterprise environments.

## Architecture

- **VPC** with public, private, and DB subnet tiers across 2 Availability Zones
- **Application Load Balancer** distributing traffic across EC2 instances
- **Auto Scaling Group** (min 2, max 4) with CPU-based scaling policies
- **RDS PostgreSQL Multi-AZ** with automated backups and encryption at rest
- **S3** for asset storage with versioning, encryption, and lifecycle rules
- **IAM Roles** with least-privilege policies (no hardcoded credentials)
- **Remote State** in S3 + DynamoDB locking for team collaboration
- **GitHub Actions CI/CD** — plan on PR, apply on merge

## Project Structure

```
modules/
├── networking/    # VPC, subnets, IGW, NAT Gateways, routing
├── compute/       # ALB, Target Group, Launch Template, ASG
├── database/      # RDS Multi-AZ, Parameter Group, Security Group
├── storage/       # S3 bucket with best-practice config
└── iam/           # EC2 Role, S3 policy, SSM access
```

## Security Highlights

- EC2 instances in **private subnets** — no public IPs
- RDS accessible **only from app security group**
- **IMDSv2 enforced** on all EC2 instances
- All storage (EBS, RDS, S3) **encrypted at rest**
- No hardcoded credentials — IAM roles + GitHub Secrets

## Quick Start

```bash
# 1. Copy and fill in variables
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars

# 2. Initialize (downloads providers, connects to remote state)
terraform init

# 3. Preview changes
terraform plan

# 4. Deploy everything
terraform apply
```

## Tech Stack

`Terraform 1.6+` · `AWS` · `VPC` · `EC2` · `ALB` · `RDS PostgreSQL` · `S3` · `IAM` · `GitHub Actions`