variable "cluster_name" {
  description = "The cluster_name"
}

variable "ecr_repository_name" {
  description = "ECR Repository name"
}

variable "ecs_service_name" {
  description = "ECS Service name"
}

variable "git_repository_owner" {
  description = "Owner from Repository"
}

variable "git_repository_name" {
  description = "Name of repository"
}

variable "git_repository_branch" {
  description = "Build branch aka Master"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "ecr_repository_url" {
  description = "The url of the ECR repository"
}

variable "region" {
  description = "The region to use"
}

variable "container_name" {
  description = "Container name"
}

variable "stage" {
  description = "Stage"
  default = "dev"
}

variable "build_timeout" {
  description = "CodeBuild Timeout"
  default = 60
}

variable "git_token" {
  description = "Git OAuth Token"
  type = string
}
