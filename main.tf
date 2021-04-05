terraform {
  # backend "remote" {
  #   organization = "hashicorp-learn"

  #   workspaces {
  #     name = "learn-terraform-pipelines-consul"
  #   }
  # }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
  }

  required_version = "~> 0.14"
}

# data "terraform_remote_state" "eks_cluster" {
#   backend = "remote"
#   config = {
#     organization = var.organization
#     workspaces = {
#       name = var.cluster_workspace
#     }
#   }
# }

data "terraform_remote_state" "eks_cluster" {
  backend = "local"
  config = {
    path = "../learn-terraform-pipelines-k8s/terraform.tfstate"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks_cluster.outputs.endpoint
  cluster_ca_certificate = data.terraform_remote_state.eks_cluster.outputs.cluster_ca_certificate
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks_cluster.outputs.cluster
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks_cluster.outputs.endpoint
    cluster_ca_certificate = data.terraform_remote_state.eks_cluster.outputs.cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.eks_cluster.outputs.cluster
      ]
    }
  }
}
