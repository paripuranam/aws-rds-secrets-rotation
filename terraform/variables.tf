variable "aws_region" {
  default = "us-east-1"
}

variable "db_identifier" {
  default = "demo-rds"
}

variable "db_name" {
  default = "appdb"
}

variable "db_username" {
  default = "admin"
}

variable "lambda_zip_path" {
  default = "../lambda/rotation-handler.zip"
}
