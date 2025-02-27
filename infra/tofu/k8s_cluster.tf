resource "vultr_kubernetes" "uk_lon_1_cp" {
  region          = "lhr"
  label           = "uk-lon-1"
  version         = "v1.32.1+1"
  enable_firewall = true


  node_pools {
    node_quantity = 2
    plan          = "vc2-2c-4gb"
    label         = "uk-lon-1-cp-node"
  }
}
