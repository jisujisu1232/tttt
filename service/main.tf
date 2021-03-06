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



module "service" {
  source       = "../modules/service"
  region       = "ap-northeast-2"
  stage        = "${terraform.workspace}"
  service_name = "jisu"
  ext_alb_subnets = "${data.terraform_remote_state.vpc.outputs.public_subnet_ids}"
  service_subnets = "${data.terraform_remote_state.vpc.outputs.private_subnet_ids}"

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

  db_instance_type = "t2.large"
  db_subnet = "${data.terraform_remote_state.vpc.outputs.database_subnet_ids[0]}"
  db_admin_cidrs = ["0.0.0.0/0"]
  env_db_user     =   "user"
  env_db_password =   "Qwer1234"
  env_rails_env   =   "development"
  db_admin_instance_key = "jisu-test"

  #service_to_db_sg = module.db.app_to_db_sg
  #env_db_host     =   "${module.db.this_db_instance_endpoint}"
  #env_db_user     =   "${module.db.this_db_instance_username}"
  #env_db_password =   "${module.db.this_db_instance_password}"
  #env_rails_env   =   "development"
  #service_bucket_name  = "jisu-service-access-log"

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
  git_token             = "388c32b5f782d2af3f90e763838bdc124b06aa55"
  vpc_id = "${data.terraform_remote_state.vpc.outputs.vpc_id}"

  ecr_repository_url = "${data.terraform_remote_state.vpc.outputs.default_ecr_url}"
  ecr_repository_name = "${data.terraform_remote_state.vpc.outputs.default_ecr_name}"

}
