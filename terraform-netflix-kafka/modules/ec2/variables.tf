variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_name" {
  type = string
}

variable "associate_public_ip" {
  type    = bool
  default = false
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "role" {
  type        = string
  description = "Role of the instance: zookeeper, kafka, or netflix_app"
}