resource "aws_db_instance" "default" {
  allocated_storage       = 10
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "Cloud123"
  db_subnet_group_name    = aws_db_subnet_group.sub_grp.name
  parameter_group_name    = "default.mysql8.0"

  # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable monitoring (CloudWatch Enhanced Monitoring)
  monitoring_interval      = 60  # Collect metrics every 60 seconds
  monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  /*# Enable performance insights @ its t3.micro is not suppoting to insights performance so use upgrade
  performance_insights_enabled          = true
  performance_insights_retention_period = 7  # Retain insights for 7 days*/

  # Maintenance window
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
  deletion_protection = false

  # Skip final snapshot
  skip_final_snapshot = false
}

# IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# DB Subnet Group
resource "aws_db_subnet_group" "sub_grp" {
  name       = "mycutsubnet"
  subnet_ids = ["subnet-09cf3579154398a14", "subnet-04a2b34e47b3f0046"]

  tags = {
    Name = "My DB subnet group"
  }
}
