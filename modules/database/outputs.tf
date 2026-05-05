output "db_endpoint" {
  value     = aws_db_instance.main.endpoint
  sensitive = true
}
output "db_identifier" {
  value = aws_db_instance.main.identifier
}
output "db_sg_id" {
  value = aws_security_group.db.id
}