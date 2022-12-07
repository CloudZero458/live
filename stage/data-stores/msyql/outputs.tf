output "address" {
  value = aws_db_instance.example.address
  description = "Connect to the db at this address"
}

output "port" {
  value = aws_db_instance.example.port
  description = "The port database is listening on"
}
