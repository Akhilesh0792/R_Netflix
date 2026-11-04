variable "project_name" {
  type = string
}

variable "peer_vpc_id" {
  type        = string
  description = "Existing Ansible EC2 VPC ID"
}

variable "target_vpc_id" {
  type        = string
  description = "Newly created Kafka VPC ID"
}

variable "peer_route_table_id" {
  type        = string
  description = "Existing Ansible EC2 Route Table ID"
}

variable "target_private_route_table_id" {
  type        = string
  description = "Newly created Kafka Private Route Table ID"
}

variable "peer_vpc_cidr" {
  type        = string
  description = "CIDR block of existing Ansible EC2 VPC (e.g. 172.31.0.0/16)"
}

variable "target_vpc_cidr" {
  type        = string
  description = "CIDR block of newly created Kafka VPC (10.0.0.0/16)"
}