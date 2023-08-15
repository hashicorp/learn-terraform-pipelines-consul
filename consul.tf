# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "helm_release" "consul" {
  depends_on = [kubernetes_namespace.secrets]
  repository = "https://helm.releases.hashicorp.com"
  name       = "${var.release_name}-consul"
  chart      = "consul"
  version    = "1.2.0"
  namespace  = var.namespace

  set {
    name  = "global.name"
    value = "consul"
  }

  set {
    name  = "server.replicas"
    value = var.replicas
  }

  set {
    name  = "server.bootstrapExpect"
    value = var.replicas
  }
}