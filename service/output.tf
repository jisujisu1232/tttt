output "ecs_service_name" {
  description = "ECS Service Name"
  value       = "${module.service.ecs_service_name}"
}

output "container_name" {
  description = "ECS Container Name"
  value = "${module.service.container_name}"
}

output "alb_endpoint" {
  description = "Service ALB Endpoint"
  value = "${module.service.alb_endpoint}"
}


output "pipeline_name" {
  description = "CodePipeline Name"
  value = "${module.pipeline.pipeline_name}"
}
