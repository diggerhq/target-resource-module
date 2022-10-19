variable "aws_app_identifier" {}

variable "cluster_identifier" {
}

variable "docdb_username" {
  default = "digger"
}

variable "docdb_port" {
  default = 27017
}

variable "instances_number" {
  default = 1
}

variable "subnet_ids" {}

variable "vpc_id" {}

variable "security_group_ids" {}

variable "instance_class" {
  default = "db.t3.medium"
}

variable "engine" {
  default = "docdb"
}
