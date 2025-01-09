resource "random_password" "password" {
  for_each = var.clusters

  length           = 30
  special          = true
  override_special = "!#$&*()-_=+[]{}<>:?"
}

locals {
  instances = {
    for name, cluster in var.clusters : "${name}" => {
      name                = "${name}"
      tier                = lookup(cluster, "instance_tier", "db-4-8")
      availability_type   = lookup(cluster, "availability_type", "regional")
      zone                = lookup(cluster, "zone", "a")
      database_version    = lookup(cluster, "database_version")
      ipv4_enabled        = lookup(cluster, "ipv4_enabled", false)
      database_flags      = lookup(cluster, "database_flags", {})
      authorized_networks = lookup(cluster, "authorized_networks", [])
      backup_location     = lookup(cluster, "backup_location", "eu")
    }
  }
}

resource "google_sql_database_instance" "instances" {
  for_each = {
    for instance in local.instances : instance.name => instance
  }
  name                = each.value.name
  region              = var.region
  database_version    = each.value.database_version

  settings {
    availability_type = each.value.availability_type
    tier              = each.value.tier
    disk_autoresize   = true

    dynamic "insights_config" {
      for_each = contains(["POSTGRES_14", "POSTGRES_13", "POSTGRES_12", "POSTGRES_11", "MYSQL_8_0_26", "MYSQL_8_0_31"], each.value.database_version) ? [true] : []
      content {
        query_insights_enabled  = true
        record_application_tags = true
      }
    }

    ip_configuration {
      ipv4_enabled    = lookup(each.value, "ipv4_enabled", false)
      private_network = var.network.self_link
      dynamic "authorized_networks" {
        for_each = each.value.authorized_networks
        iterator = authorized_network
        content {
          name  = authorized_network.key
          value = authorized_network.value
        }
      }
    }

    backup_configuration {
      binary_log_enabled             = contains(["POSTGRES_14", "POSTGRES_13", "POSTGRES_12", "POSTGRES_11"], each.value.database_version) ? false : true
      enabled                        = true
      point_in_time_recovery_enabled = contains(["POSTGRES_14", "POSTGRES_13", "POSTGRES_12", "POSTGRES_11"], each.value.database_version) ? true : false
      start_time                     = "03:00"
      location                       = each.value.backup_location
      backup_retention_settings {
        retained_backups = 30
      }
    }
    maintenance_window {
      day  = 3
      hour = 1
    }

    location_preference {
      zone = "${var.region}-${each.value.zone}"
    }

    dynamic "database_flags" {
      for_each = each.value.database_flags
      iterator = database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }
  }
  lifecycle {
    ignore_changes = [
      settings[0].location_preference[0].secondary_zone
    ]
  }
}
resource "google_sql_user" "user" {
  for_each = var.clusters

  depends_on = [
    google_sql_database_instance.instances,
  ]

  instance = each.key
  name     = "root"
  password = random_password.password[each.key].result
  host     = contains(["POSTGRES_14", "POSTGRES_13", "POSTGRES_12", "POSTGRES_11"], each.value.database_version) ? "" : "%" # only set host for non-postgres systems
}
