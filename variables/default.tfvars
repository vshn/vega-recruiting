gcp_project_id = "myproject-id"
region = "europe-west3"

sql_cloud_clusters = {
  recruiting-db1 = {
    database_version = "MYSQL_8_0_31"
    instance_tier    = "db-custom-4-12288"
    zone             = "b"
    database_flags = {
      sql_mode = "ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES"
    }
  },
  recruiting-db2 = {
    database_version = "POSTGRES_14"
    instance_tier    = "db-custom-4-12288"
    zone             = "a"
  }
}

storage_buckets = {
    bucket1 = {}
    bucket2 = {}
}