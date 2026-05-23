variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}