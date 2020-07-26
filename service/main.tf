data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = "${terraform.workspace}"
  config = {
    bucket = "jisu-terraform-test"
    key    = "terraform/moduleExample/ref_remote_state/vpc/terraform.state"
    region = "ap-northeast-2"
  }
}

variable "custom_tags" {
  default = {
    "TerraformManaged" = "true"
  }
}






# https://github.com/terraform-aws-modules/terraform-aws-rds
module "db" {
  source = "../modules/rds"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.large"
  allocated_storage = 5
  storage_encrypted = false

  name     = "demodb"
  username = "user"
  password = "Qwer1234"
  port     = "3306"

  #vpc_security_group_ids = ["${module.service.db_security_group_id}"]
  vpc_id             = "${data.terraform_remote_state.vpc.outputs.vpc_id}"
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  db_admin_cidrs = ["0.0.0.0/0"]
  multi_az = true

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Environment = "${terraform.workspace}"
  }

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  # DB subnet group
  db_subnet_group_name = "${data.terraform_remote_state.vpc.outputs.database_subnet_group_ids[0]}"

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "demodb"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}


module "service" {
  source       = "../modules/service"
  region       = "ap-northeast-2"
  stage        = "${terraform.workspace}"
  service_name = "jisu"
  ext_alb_subnets = "${data.terraform_remote_state.vpc.outputs.public_subnet_ids}"
  service_subnets = "${data.terraform_remote_state.vpc.outputs.private_subnet_ids}"
  service_to_db_sg = module.db.app_to_db_sg
  vpc_id = "${data.terraform_remote_state.vpc.outputs.vpc_id}"
  app_port = 3000
  health_check_path = "/"
  ecs_cluster_name = "${data.terraform_remote_state.vpc.outputs.default_ecs_cluster_name}"
  ecs_cluster_id = "${data.terraform_remote_state.vpc.outputs.default_ecs_cluster_id}"
  app_image = "${data.terraform_remote_state.vpc.outputs.default_ecr_url}:latest"
  fargate_cpu = 1024
  fargate_memory = 2048
  app_min_size = 2
  app_max_size = 5
  scale_in_cpu = 10
  scale_out_cpu = 60

  env_db_host     =   "${module.db.this_db_instance_endpoint}"
  env_db_user     =   "${module.db.this_db_instance_username}"
  env_db_password =   "${module.db.this_db_instance_password}"
  env_rails_env   =   "development"

  custom_tags           = "${var.custom_tags}"
}



module "pipeline" {
  source = "../modules/pipeline"
  region       = "ap-northeast-2"
  cluster_name = "${data.terraform_remote_state.vpc.outputs.default_ecs_cluster_name}"

  ecs_service_name = "${module.service.ecs_service_name}"
  container_name = "${module.service.container_name}"

  git_repository_owner = "jisujisu1232"
  git_repository_name = "rails-realworld-example-app"
  git_repository_branch = "master"
  git_token             = "b0b0a4fd5ede540a5a98862c342642a50d14f513"
  vpc_id = "${data.terraform_remote_state.vpc.outputs.vpc_id}"

  ecr_repository_url = "${data.terraform_remote_state.vpc.outputs.default_ecr_url}"
  ecr_repository_name = "${data.terraform_remote_state.vpc.outputs.default_ecr_name}"

}
