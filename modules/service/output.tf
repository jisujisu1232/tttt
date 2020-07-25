output "ecs_service_name" {
  description = "ECS Service Name"
  value       = "${aws_ecs_service.main.name}"
}

output "container_name" {
  description = "ECS Container Name"
  value = "${var.service_name}-${var.stage}"
}
