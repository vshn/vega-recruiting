variable "name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
}

variable "gcp_region" {
  description = "GCP Region"
}
