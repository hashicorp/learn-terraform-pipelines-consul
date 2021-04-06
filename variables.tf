variable "release_name" {
  type        = string
  default     = "hashicorp-learn"
  description = "Helm Release name for Consul chart"
}

variable "namespace" {
  type        = string
  default     = "hashicorp-learn"
  description = "Namespace to deploy the Consul Helm chart"
}

variable "cluster_workspace" {
  type        = string
  default     = ""
  description = "Workspace that created the Kubernetes cluster"
}

variable "organization" {
  type        = string
  default     = "infrastructure-pipelines-workshop"
  description = "Organization of workspace that created the Kubernetes cluster"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of consul replicas"
}