provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_namespace" "main" {
  metadata {
    name = "idp30"
  }
}
resource "kubernetes_resource_quota" "main" {
  metadata {
    name = "idpquota30"
    namespace = "idp30"
  }
  spec {
    hard = {
      "pods" = "10"
      "limits.cpu" = "5"
      "limits.memory"   = "10Gi"
    }
  }
}
