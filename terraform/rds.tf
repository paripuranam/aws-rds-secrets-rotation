data "aws_db_instance" "target" {
  db_instance_identifier = var.db_instance_identifier
}

output "rds_endpoint" {
  value = data.aws_db_instance.target.address
}
