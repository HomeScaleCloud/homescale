data "onepassword_vault" "cluster" {
  name = var.cluster
}

data "onepassword_item" "onepassword" {
  vault = var.cluster
  title = "onepassword"
}

data "onepassword_item" "argocd_oidc" {
  vault = "common"
  title = "argocd-oidc"
}

data "onepassword_item" "grafana_oidc" {
  vault = "common"
  title = "grafana-oidc"
}

data "onepassword_item" "entra_tenant" {
  vault = "common"
  title = "entra-tenant"
}

resource "onepassword_item" "talosconfig" {
  count    = var.store_talosconfig ? 1 : 0
  vault    = data.onepassword_vault.cluster.uuid
  title    = "talosconfig"
  password = data.talos_client_configuration.controlplane.talos_config
}

resource "onepassword_item" "kubeconfig" {
  count    = var.store_kubeconfig ? 1 : 0
  vault    = data.onepassword_vault.cluster.uuid
  title    = "kubeconfig"
  password = talos_cluster_kubeconfig.cluster.kubeconfig_raw
}

resource "kubernetes_secret" "onepassword" {
  count = (var.cluster_init || var.cluster_init_core_apps) ? 0 : (var.app_onepassword_enabled ? 1 : 0)
  metadata {
    name      = "onepassword"
    namespace = "onepassword"
  }
  data = {
    credential = data.onepassword_item.onepassword.credential
    password   = data.onepassword_item.onepassword.password
  }
}

resource "kubernetes_secret" "tailscale" {
  count = (var.cluster_init || var.cluster_init_core_apps) ? 0 : (var.app_tailscale_enabled ? 1 : 0)
  metadata {
    name      = "operator-oauth"
    namespace = "tailscale"
  }
  data = {
    client_id     = tailscale_oauth_client.k8s_operator.id
    client_secret = tailscale_oauth_client.k8s_operator.key
  }
}