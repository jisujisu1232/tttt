resource "aws_s3_bucket" "source" {
  bucket        = "${var.cluster_name}-${var.ecs_service_name}-${var.stage}-pipeline"
  acl           = "private"
  force_destroy = true
}
