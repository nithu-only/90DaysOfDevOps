variable "region" {
  type = string
}

variable "cluster_name" {
  default = "terraweek-eks"
}

variable "cluster_version" {
  default = "1.31"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "node_desired_count" {
  default = 2
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}