resource "digitalocean_kubernetes_cluster" "core" {
  name    = "core"
  region  = "lon1"
  version = "1.32.2-do.0"

  node_pool {
    name       = "core-node"
    size       = "s-2vcpu-4gb"
    node_count = 2
  }
}
