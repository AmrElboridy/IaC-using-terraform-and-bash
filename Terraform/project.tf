resource "kubernetes_resource_quota" "main" {

  metadata {

    name = "${var.project}-quota"

    namespace = "${var.project}"

  }

  spec {

    hard = {

      "pods"             = var.quota_pods

      "requests.cpu"     = var.quota_cpu_request

      "requests.memory"  = var.quota_memory_request

      "limits.cpu"       = var.quota_cpu_limit

      "limits.memory"    = var.quota_memory_limit

      "requests.storage" = var.quota_storage

 

    }

  }

}