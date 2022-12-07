variable "db_username" {
  description = "The username for the database"
  type = string
  sensitive = true # terraform won't log the values when you run plan or apply
}

variable "db_password" {
  description = "The password for the database"
  type = string
  sensitive = true # terraform won't log the values when you run plan or apply
}
