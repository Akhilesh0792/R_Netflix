variable "aws_region" { type = string }
variable "project_name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = map(object({ cidr = string, az = string })) }
variable "private_subnets" { type = map(object({ cidr = string, az = string })) }
variable "kafka_nodes" { type = map(object({ subnet_key = string, disk_size = number })) }

variable "control_vpc_id" {
  type = string
}

variable "control_route_table_id" {
  type = string
}

variable "control_vpc_cidr" {
  type = string
}