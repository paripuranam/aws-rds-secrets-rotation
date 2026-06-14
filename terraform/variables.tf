variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}

variable "db_instance_identifier" {
  description = "Existing RDS instance identifier"
  type        = string
}
