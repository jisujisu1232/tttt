output "pipeline_name" {
  description = "CodePipeline Name"
  value = "${var.cluster_name}-${var.ecs_service_name}-${var.stage}-pipeline"
}
