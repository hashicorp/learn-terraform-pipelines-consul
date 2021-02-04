output "namespace" {
  value = var.namespace
}

output "release_name" {
  value = var.release_name
}

output "project_id" {
  value = data.google_client_config.default.project
}

output "region" {
  value = data.google_client_config.default.region
}


output "cluster" {
  value = google_container_cluster.engineering.name
}
