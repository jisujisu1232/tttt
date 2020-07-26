variable "region" {
  description = "AWS Region"
  default     = "ap-northeast-2"
}

variable "stage" {
  description = "Stage"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ext_alb_subnets" {
  description = "EXT Service ALB Subnets"
  type        = list
}

variable "service_subnets" {
  description = "Service Subnets"
  type        = list
}

variable "service_name" {
  description = "Service Name"
  type        = string
}

variable "app_port" {
  description = "Appication Port"
  default     = 80
}

variable "health_check_path" {
  description = "Health Check Path"
  default     = "/"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type = string
}

variable "ecs_cluster_id" {
  description = "ECS Cluster ID"
  type = string
}

variable "app_image" {
  description = "service Image"
  type = string
  default = ""
}

variable "fargate_cpu" {
  description = "ECS Service CPU"
  default = 1024
}

variable "fargate_memory" {
  description = "ECS Service Memory"
  default = 512
}

variable "app_min_size" {
  description = "Service Min Size"
  default = 2
}

variable "app_max_size" {
  description = "Service Max Size"
  default = 2
}


variable "scale_in_cpu" {
  description = "Service Scale In CPU Utilization"
  default = 20
}

variable "scale_out_cpu" {
  description = "Service Scale Out CPU Utilization"
  default = 60
}


variable "db_admin_cidrs" {
  description = "Mysql Admin CIDRs"
  type = list
  default = ["255.255.255.255/32"]
}

variable "db_instance_type" {
  description = "Mysql EC2 Type"
  type = string
  default = "t2.large"
}


variable "db_subnet" {
  description = "Mysql EC2 Subnet"
  type = string
}


variable "env_rails_env" {
  description = "Docker ENV RAILS_ENV"
  type = string
}

variable "env_db_user" {
  description = "Docker ENV DB_USER"
  type = string
}

variable "env_db_password" {
  description = "Docker ENV DB_PASSWORD"
  type = string
}

variable "db_port" {
  description = "Mysql Service Port"
  type = string
  default = "3306"
}

variable "db_admin_instance_key" {
  description = "Mysql EC2 Key"
  type = string
}

variable "custom_tags" {
  description = "custom tags"
  type        = map
}

variable "service_bucket_name" {
  description = "custom tags"
  type        = string
  default = ""
}

variable "log_expiration_days" {
  description = "log expiration days"
  default = 90
}
