variable "aws_app_identifier" {}

variable "allocated_storage" {
  type        = number
  default     = 100
  description = "The default storage for the RDS instance"
} 


variable "cluster_id" {
}

variable "cluster_description" {}

variable "redis_node_type" {
  default = "cache.t3.micro"
}

variable "engine_version" {
}

variable "redis_port" {
  default = 6379
}

variable "redis_number_nodes" {
  default = 2
}

variable "vpc_id" {}

variable "subnet_ids" {}

variable "security_group_ids" {}

variable "tags" {}

