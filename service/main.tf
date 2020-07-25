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
  app_image = "nginx:latest"
  fargate_cpu = 1024
  fargate_memory = 2048
  app_min_size = 2
  app_max_size = 5
  scale_in_cpu = 10
  scale_out_cpu = 60
  custom_tags           = "${var.custom_tags}"
}
