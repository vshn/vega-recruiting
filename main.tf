provider "google" {
  project = var.gcp_project_id
  region  = var.region
}

module "vpc" {
  source = "./modules/vpc"

  name                       = terraform.workspace
  vpc_cidr                   = var.vpc_cidr
  region                     = var.region
}

module "databases" {
  source = "./modules/database"

  name     = terraform.workspace
  clusters = var.sql_cloud_clusters
  project_id              = var.gcp_project_id
  region                  = var.region
  subnetwork              = module.vpc.subnet.name
  network                 = module.vpc.network
}

module "storage" {
  source = "./modules/storage"
  storage_buckets = var.storage_buckets
}