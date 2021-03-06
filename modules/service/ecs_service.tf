data "template_file" "myapp" {
  template = file("${path.module}/templates/app.json.tpl")

  vars = {
    service_name   = var.service_name
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.region
    stage          = var.stage
    env_db_host    = "${aws_instance.mysql.private_ip}"
    env_db_user    = var.env_db_user
    env_db_password= aws_secretsmanager_secret_version.db_password.arn
    env_rails_env  = var.env_rails_env
  }
}

resource "random_string" "lower" {
  length  = 10
  upper   = false
  lower   = true
  number  = false
  special = false
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.service_name}-${var.stage}-mysql-passwd-${random_string.lower.result}"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = "${aws_secretsmanager_secret.db_password.id}"
  secret_string = var.env_db_password
}

resource "aws_cloudwatch_log_group" "service_log_group" {
  name              = "/ecs/${var.service_name}-${var.stage}"
  retention_in_days = 30

  tags = {
    Name = "service-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "service_log_stream" {
  name           = "service-log-stream"
  log_group_name = aws_cloudwatch_log_group.service_log_group.name
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.service_name}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp.rendered
  depends_on = [aws_alb_listener.http, aws_iam_role_policy_attachment.ecs_task_execution_role]
  #lifecycle {
  #  ignore_changes = [
  #    container_definitions[0].image
  #  ]
  #}
}

resource "aws_ecs_service" "main" {
  name            = "${var.service_name}-service"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_min_size
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.service.id, aws_security_group.app_to_db.id]
    subnets          = "${var.service_subnets}"
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.default.id
    container_name   = "${var.service_name}-${var.stage}"
    container_port   = var.app_port
  }

  depends_on = [aws_ecs_task_definition.app]
}
