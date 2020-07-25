# 인터넷페이싱 ALB SG
resource "aws_security_group" "ext_alb" {
  name        = "ext-service-alb-sg"
  description = "controls access to the ALB"
  vpc_id      = "${var.vpc_id}"

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ext_alb_https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "${var.service_name} HTTPS"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.ext_alb.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "ext_alb_http" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "${var.service_name} HTTP"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.ext_alb.id}"
  to_port           = 80
  type              = "ingress"
}


# ECS Service SG
resource "aws_security_group" "service" {
  name        = "service-sg"
  description = "Application ${var.service_name} Security Group"
  vpc_id      = "${var.vpc_id}"

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "service_port" {
  description       = "${var.service_name} HTTP"
  security_group_id = "${aws_security_group.service.id}"
  source_security_group_id = "${aws_security_group.ext_alb.id}"
  protocol          = "tcp"
  from_port         = "${var.app_port}"
  to_port           = "${var.app_port}"
  type              = "ingress"
}


# Database Security Group
resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "${var.service_name} Security Group"
  vpc_id      = "${var.vpc_id}"

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "service_to_db" {
  description       = "${var.service_name} DB for Service"
  security_group_id = "${aws_security_group.db.id}"
  source_security_group_id = "${aws_security_group.service.id}"
  protocol          = "tcp"
  from_port         = "${var.db_port}"
  to_port           = "${var.db_port}"
  type              = "ingress"
}

resource "aws_security_group_rule" "admin_to_db" {
  description       = "${var.service_name} DB for Admin"
  security_group_id = "${aws_security_group.db.id}"
  cidr_blocks       = "${var.db_admin_cidrs}"
  protocol          = "tcp"
  from_port         = "${var.db_port}"
  to_port           = "${var.db_port}"
  type              = "ingress"
}
