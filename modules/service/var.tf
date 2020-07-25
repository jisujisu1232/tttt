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



variable "custom_tags" {
  description = "custom tags"
  type        = map
}
