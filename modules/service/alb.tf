resource "aws_alb" "ext_alb" {
  name            = "ext-${var.service_name}-alb"
  subnets         = "${var.ext_alb_subnets}"
  security_groups = [aws_security_group.ext_alb.id]
}

resource "aws_alb_target_group" "default" {
  name        = "ext-service-alb-default-tg"
  port        = "${var.app_port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "${var.health_check_path}"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.ext_alb.id}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}
