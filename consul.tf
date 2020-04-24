resource "helm_release" "consul" {
  count      = data.terraform_remote_state.cluster.outputs.enable_consul_and_vault ? 1 : 0
  depends_on = [kubernetes_namespace.secrets]
  name       = "${var.release_name}-consul"
  chart      = "${path.module}/consul-helm"
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