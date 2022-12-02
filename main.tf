terraform {
  backend "remote" {
    organization = "terraform201-ob"

    workspaces {
      name = "learn-terraform-pipelines-consul"
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

  required_version = "~> 1.3.5"
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
  project     = data.terraform_remote_state.cluster.outputs.project_id
  region      = data.terraform_remote_state.cluster.outputs.region
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.host
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.cluster_ca_certificate

}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.host
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.cluster_ca_certificate

  }
}
