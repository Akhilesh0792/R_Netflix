variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB is deployed"
  type        = string
}

variable "security_group_ids" {
  description = "Security Group IDs for ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs for ALB"
  type        = list(string)
}

variable "target_instance_id" {
  description = "Instance ID of Netflix frontend EC2"
  type        = string
}