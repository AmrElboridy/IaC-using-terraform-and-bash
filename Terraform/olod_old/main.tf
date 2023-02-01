
provider "kubernetes" {
  #load_config_file = "false"
  config_path = var.ConfigPath
}


resource "kubernetes_namespace" "main" {
  metadata {
    name =  var.project
    }
}


