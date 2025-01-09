locals {
  storage_buckets = {
    for name, bucket in var.storage_buckets : name => {
      name          = name
      location      = lookup(bucket, "location", "EU")
      storage_class = lookup(bucket, "storage_class", "STANDARD")
    }
  }
}


resource "google_storage_bucket" "cloud_storage" {
  for_each      = local.storage_buckets
  name          = each.key
  location      = each.value.location
  storage_class = each.value.storage_class

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      days_since_noncurrent_time = 90
    }
    action {
      type = "Delete"
    }
  }
}