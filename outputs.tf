output "namespace" {
  description = "Namespace containing the Consul Helm chart"
  value       = var.namespace
}

output "release_name" {
  description = "Helm Release name for Consul chart"
  value       = var.release_name
}
