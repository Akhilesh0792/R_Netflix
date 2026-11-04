variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "security_group_ids" { type = list(string) }
variable "subnet_ids" { type = list(string) }
variable "target_instance_id" { type = string }