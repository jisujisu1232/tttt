output "db_security_group_id" {
  description = "Database Security Group ID"
  value       = "${aws_security_group.db.id}"
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = "${aws_ecs_service.main.name}"
}

output "container_name" {
  description = "ECS Container Name"
  value = "${service_name}-${stage}"
}
