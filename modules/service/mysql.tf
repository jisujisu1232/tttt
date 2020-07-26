data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }
}

# Database Security Group
resource "aws_security_group" "db" {
  name        = "${var.service_name}-${var.stage}-db-sg"
  description = "${var.service_name}-${var.stage}-db Security Group"
  vpc_id      = "${var.vpc_id}"

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_to_db" {
  name        = "${var.service_name}-${var.stage}-db-for-app-sg"
  description = "${var.service_name}-${var.stage}-db Security Group For App"
  vpc_id      = "${var.vpc_id}"
}


resource "aws_security_group_rule" "admin_to_db" {
  description       = "${var.service_name}-${var.stage}-db for Admin DB"
  security_group_id = "${aws_security_group.db.id}"
  cidr_blocks       = "${var.db_admin_cidrs}"
  protocol          = "tcp"
  from_port         = "${var.db_port}"
  to_port           = "${var.db_port}"
  type              = "ingress"
}


resource "aws_security_group_rule" "admin_to_db_ssh" {
  description       = "${var.service_name}-${var.stage}-db for Admin SSH"
  security_group_id = "${aws_security_group.db.id}"
  cidr_blocks       = "${var.db_admin_cidrs}"
  protocol          = "tcp"
  from_port         = "22"
  to_port           = "22"
  type              = "ingress"
}

resource "aws_security_group_rule" "app_to_db_service" {
  description       = "${var.service_name}-${var.stage}-db for App"
  security_group_id = "${aws_security_group.db.id}"
  source_security_group_id       = "${aws_security_group.app_to_db.id}"
  protocol          = "tcp"
  from_port         = "${var.db_port}"
  to_port           = "${var.db_port}"
  type              = "ingress"
}



locals {
  mysql-userdata = <<MYSQLUSERDATA
#!/bin/bash
sudo yum install mysql57-server -y
service mysqld start
echo "create user ${var.env_db_user}@'%' identified by '${var.env_db_password}';\ncreate database sample_development;\ngrant all privileges on sample_development.* to ${var.env_db_user}@'%' identified by '${var.env_db_password}';"|mysql -u root
MYSQLUSERDATA
}

resource "aws_instance" "mysql" {
  ami                    = "${data.aws_ami.amazon-linux.id}"
  instance_type          = "${var.db_instance_type}"
  key_name               = "${var.db_admin_instance_key}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  subnet_id              = "${var.db_subnet}"
  user_data_base64       = "${base64encode(local.mysql-userdata)}"
  tags = "${
    map(
      "Name", "${var.service_name}-${var.stage}-db"
    )
  }"
}
