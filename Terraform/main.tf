
provider "kubernetes" {
  #load_config_file = "false"
  config_path    = "~/.kube/config"
}


resource "kubernetes_namespace" "main" {
  metadata {
    name =  var.project
    annotations =  {
      node_selector =  {
		"env" = "prod"
	}
    }
  }
}


