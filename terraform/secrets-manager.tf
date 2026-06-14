resource "aws_secretsmanager_secret" "rds_secret" {
  name                    = "${var.db_instance_identifier}-credentials"
  description             = "RDS credentials managed by Secrets Manager"
  recovery_window_in_days = 7

  tags = {
    Project = "aws-database-secrets-rotation"
  }
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_secret.id

  secret_string = jsonencode({
    username             = var.db_username
    password             = var.db_password
    engine               = "mysql"
    host                 = data.aws_db_instance.target.address
    port                 = data.aws_db_instance.target.port
    dbname               = var.db_name
    dbInstanceIdentifier = data.aws_db_instance.target.id
  })
}
