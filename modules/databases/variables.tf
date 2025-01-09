variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "network" {
  type = any
}

variable "subnetwork" {
  type = string
}

variable "clusters" {
  description = "List of cluster configurations"
  type        = any
}
