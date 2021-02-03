terraform {
  backend "remote" {
    organization = "hashicorp-rachel"

    workspaces {
      name = "firstName-lastInitial-consul"
    }
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.2"
    }
  }

  required_version = "~> 0.14"
}



data "terraform_remote_state" "cluster" {
  backend = "remote"
  config = {
    organization = var.organization
    workspaces = {
      name = var.cluster_workspace
    }
  }
}



# Retrieve GKE cluster information
provider "google" {
  project = data.terraform_remote_state.cluster.outputs.project_id
  region  = data.terraform_remote_state.cluster.outputs.region
}

# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

data "google_container_cluster" "my_cluster" {
  name     = data.terraform_remote_state.cluster.outputs.kubernetes_cluster_name
  location = data.terraform_remote_state.cluster.outputs.region
}

provider "kubernetes" {
  host = data.terraform_remote_state.cluster.outputs.kubernetes_cluster_host

  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.host
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  }
}