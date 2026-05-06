# Root module — wires all child modules together

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# 1. Networking
module "networking" {
  source = "./modules/networking"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
}

# 2. IAM 
module "iam" {
  source = "./modules/iam"

  name_prefix   = local.name_prefix
  s3_bucket_arn = module.storage.bucket_arn
}

#  3. Storage 
module "storage" {
  source = "./modules/storage"

  name_prefix = local.name_prefix
  environment = var.environment
}

# 4. Database 
module "database" {
  source            = "./modules/database"
  name_prefix       = local.name_prefix
  db_subnet_ids     = module.networking.db_subnet_ids
  vpc_id            = module.networking.vpc_id
  app_sg_id         = module.compute.app_sg_id
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  db_engine_version = var.db_engine_version
}

# 5. Compute (ALB + ASG) 
module "compute" {
  source = "./modules/compute"

  name_prefix          = local.name_prefix
  vpc_id               = module.networking.vpc_id
  public_subnet_ids    = module.networking.public_subnet_ids
  private_subnet_ids   = module.networking.private_subnet_ids
  instance_type        = var.instance_type
  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
  iam_instance_profile = module.iam.instance_profile_name
  s3_bucket_name       = module.storage.bucket_name
  db_endpoint          = module.database.db_endpoint
}