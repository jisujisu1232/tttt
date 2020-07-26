data "template_file" "buildspec" {
  template = "${file("${path.module}/templates/buildspec.yml")}"

  vars = {
    repository_uri = "${var.ecr_repository_url}"
    region         = "${var.region}"
    cluster_name   = "${var.cluster_name}"
    container_name = "${var.container_name}"
    service_name   = "${var.ecs_service_name}"
  }
}

resource "aws_codebuild_project" "app_build" {
  name          = "${var.cluster_name}-${var.ecs_service_name}-${var.stage}-codebuild"
  build_timeout = "${var.build_timeout}"

  service_role = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    // https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "${data.template_file.buildspec.rendered}"
  }
}
