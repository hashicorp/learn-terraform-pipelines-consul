terraform {
  backend "remote" {
    organization = "infrastructure-pipelines-workshop"

    workspaces {
      name = "rachel-s-consul"
    }
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.1"
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

data "google_container_cluster" "my_cluster" {
  name     = "my-cluster"
  location = "us-central1"
}


data "google_client_config" "default" {
}

provider "kubernetes" {
  host     = data.terraform_remote_state.cluster.outputs.host
  username = data.terraform_remote_state.cluster.outputs.username
  password = data.terraform_remote_state.cluster.outputs.password
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.cluster_ca_certificate,
  )
}


provider "helm" {
  kubernetes {
    host     = data.terraform_remote_state.cluster.outputs.host
    username = data.terraform_remote_state.cluster.outputs.username
    password = data.terraform_remote_state.cluster.outputs.password
    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.cluster.outputs.cluster_ca_certificate,
    )
  }
}
