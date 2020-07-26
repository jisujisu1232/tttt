# ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

data "template_file" "ecs_task_secret" {
  template = "${file("${path.module}/templates/ecs_secrets_policy.json")}"

  vars = {
    aws_account_id = "${data.aws_caller_identity.current.account_id}"
    region        = "${var.region}"
    secret_name   = "${var.service_name}-${var.stage}-*"
  }
}



# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.service_name}-ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_secret_policy" {
  name   = "${var.service_name}-${var.stage}-policy"
  role   = "${aws_iam_role.ecs_task_execution_role.id}"
  policy = "${data.template_file.ecs_task_secret.rendered}"
}
