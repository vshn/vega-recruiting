variable "gcp_project_id" {
  description = "GCP project ID"
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  default = "10.0.0.0.0/8"
}

variable "region" {
  description = "GCP Region"
}

variable "sql_cloud_clusters" {
  description = "Configuration of Cloud SQL clusters"
  type        = any
  default     = {}
}

variable "storage_buckets" {
  description = "Cloud storage buckets"
  default     = {}
}