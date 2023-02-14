resource "helm_release" "consul" {
  depends_on = [kubernetes_namespace.secrets]
  name       = "${var.release_name}-consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
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