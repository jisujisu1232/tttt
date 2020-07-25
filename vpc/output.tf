# VPC
output "vpc_id" {
  description = "VPC ID"
  value       = "${module.vpc.vpc_id}"
}

output "vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = "${module.vpc.vpc_cidr_block}"
}

output "default_network_acl_id" {
  description = "VPC default network ACL ID"
  value       = "${module.vpc.default_network_acl_id}"
}

# internet gateway
output "igw_id" {
  description = "Interget Gateway ID"
  value       = "${module.vpc.igw_id}"
}

# subnets
output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = "${module.vpc.private_subnet_ids}"
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = "${module.vpc.public_subnet_ids}"
}

output "database_subnet_ids" {
  description = "Database Subnet IDs"
  value       = "${module.vpc.database_subnet_ids}"
}

output "database_subnet_group_ids" {
  description = "Database Subnet Group IDs"
  value       = "${module.vpc.database_subnet_group_ids}"
}

output "subnet_pub_info" {
  description = "Public Subnet Infomations"
  value       = "${module.vpc.subnet_pub_info}"
}

output "subnet_pri_info" {
  description = "Private Subnet Infomations"
  value       = "${module.vpc.subnet_pri_info}"
}

output "subnet_data_info" {
  description = "Database Subnet Infomations"
  value       = "${module.vpc.subnet_data_info}"
}

# route tables
output "public_route_table_ids" {
  description = "Public Route Table IDs"
  value       = "${module.vpc.public_route_table_ids}"
}

output "private_route_table_ids" {
  description = "Private Route Table IDs"
  value       = "${module.vpc.private_route_table_ids}"
}

output "database_route_table_ids" {
  description = "Database Route Table IDs"
  value       = "${module.vpc.database_route_table_ids}"
}

# NAT gateway
output "nat_eip_ids" {
  description = "NAT Gateway EIP IDs"
  value       = "${module.vpc.nat_eip_ids}"
}

output "nat_public_ips" {
  description = "NAT Gateway EIPs"
  value       = "${module.vpc.nat_public_ips}"
}

output "natgw_ids" {
  description = "NAT Gateway IDs"
  value       = "${module.vpc.natgw_ids}"
}

output "region" {
  description = "region"
  value       = "${module.vpc.region}"
}

output "default_ecs_cluster_name" {
  description = "Default ECS Cluster Name"
  value       = "${module.vpc.default_ecs_cluster_name}"
}

output "default_ecs_cluster_id" {
  description = "Default ECS Cluster Name"
  value       = "${module.vpc.default_ecs_cluster_id}"
}

output "default_ecr_name" {
  description = "Default ECR Name"
  value       = "${module.vpc.default_ecr_name}"
}

output "default_ecr_url" {
  description = "Default ECR URL"
  value       = "${module.vpc.default_ecr_url}"
}
