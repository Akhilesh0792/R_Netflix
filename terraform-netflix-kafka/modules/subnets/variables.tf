variable "vpc_id" { type = string }
variable "igw_id" { type = string }
variable "project_name" { type = string }
variable "public_subnets" { type = map(object({ cidr = string, az = string })) }
variable "private_subnets" { type = map(object({ cidr = string, az = string })) }