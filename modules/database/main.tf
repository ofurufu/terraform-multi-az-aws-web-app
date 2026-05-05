# ─── DB Subnet Group ──────────────────────────────────────────────────────────
resource "aws_db_subnet_group" "main" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags       = { Name = "${var.name_prefix}-db-subnet-group" }
}

# ─── Security Group (only accepts connections from app layer) ─────────────────
resource "aws_security_group" "db" {
  name        = "${var.name_prefix}-sg-db"
  description = "Allow PostgreSQL access from app layer only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from app SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-sg-db" }
}

# ─── Parameter Group ──────────────────────────────────────────────────────────
resource "aws_db_parameter_group" "main" {
  family = "postgres12"
  name   = "${var.name_prefix}-pg12-params"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = { Name = "${var.name_prefix}-pg12-params" }
}

# ─── RDS Instance (Multi-AZ = automatic standby in second AZ) ────────────────
resource "aws_db_instance" "main" {
  identifier = "${var.name_prefix}-db"

  # Engine
  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  parameter_group_name = aws_db_parameter_group.main.name

  # Storage
  allocated_storage     = 20
  max_allocated_storage = 100      # Auto-scaling storage up to 100 GB
  storage_type          = "gp3"
  storage_encrypted     = true     # Encryption at rest

  # Credentials
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false   # NEVER expose RDS to the internet

  # High Availability
  multi_az = true

  # Backup
  backup_retention_period   = 7          # 7-day point-in-time recovery
  backup_window             = "03:00-04:00"
  maintenance_window        = "sun:04:00-sun:05:00"
  delete_automated_backups  = false

  # Production safety
  deletion_protection       = false      # Set to true in prod!
  skip_final_snapshot       = true       # Set to false in prod!
  # final_snapshot_identifier = "${var.name_prefix}-db-final-snapshot"

  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7

  tags = { Name = "${var.name_prefix}-db" }
}