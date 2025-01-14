# 🖧 morrislan

### Infrastructure as Code (IaC) for [my](https://maxmorris.io) personal network/digital infrastructure.
![terraform](https://git.morrislan.net/MorrisLAN/morrislan/actions/workflows/terraform.yml/badge.svg?branch=prod)
![podman](https://git.morrislan.net/MorrisLAN/morrislan/actions/workflows/podman.yml/badge.svg?branch=prod)
![omni](https://git.morrislan.net/MorrisLAN/morrislan/actions/workflows/omni.yml/badge.svg?branch=prod)

![argocd](https://argocd.morrislan.net/api/badge?name=argocd&showAppName=true)


🔧 **Technologies in Use:**

- [Gitea](https://about.gitea.com/) - GitOps/CI platform
- [Terraform](https://www.terraform.io/) - IaC tool
- [Kubernetes (k8s)](https://kubernetes.io/) - workload/container orchestrator
- [netbird](https://netbird.io/) - open-source P2P VPN
- [Talos Linux](https://www.talos.dev/) - API-managed OS that is purpose built for running k8s
- [Omni](https://omni.siderolabs.com/) - centralised machine & cluster management for Talos
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) - GitOps for k8s
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx) - ingress controller for k8s
- [cert-manager](https://cert-manager.io/) - automated certificate retrieval for k8s
- [external-dns](https://kubernetes-sigs.github.io/external-dns/v0.14.0/) - provisioning of DNS records from within k8s
- [Authentik](https://goauthentik.io/) - Identity provider/user management for SSO
- [Cloudflare Access/Tunnels](https://www.cloudflare.com/en-gb/zero-trust/products/access/) - Secure access to services & apps
- [Home Assistant](https://www.home-assistant.io/) - Smart home controller
- [generic-device-plugin](https://github.com/squat/generic-device-plugin) - attaches special Linux devices to k8s pods
- [Kata Containers](https://katacontainers.io/) - VM-based container runtime
- [Falco](https://falco.org/) - threat analysis tool
- [LibreSpeed](https://github.com/librespeed/speedtest) - Self hosted speedtest
- [metrics-server](https://github.com/kubernetes-sigs/metrics-server) - k8s metrics API
- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) - monitoring/metrics stack
- [rook-ceph](https://rook.io/) - distributed storage for k8s
- [Trivy Operator](https://github.com/aquasecurity/trivy-operator) - security toolkit for k8s
- [Vault](https://www.vaultproject.io/) - secrets management engine
- [metrics-server](https://kubernetes-sigs.github.io/metrics-server/) - resource metrics for k8s