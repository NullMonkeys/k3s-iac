Multi-node k3s cluster on Oracle Cloud Infrastructure, provisioned with Terraform (HCP), configured with Ansible, and managed via ArgoCD.

> [!NOTE]
> This is our internal setup. It requires HCP Terraform and manual Ansible inventory management. You probably shouldn't use it :)

## Architecture

- **Terraform** provisions OCI network (VCN, subnet, security list) and compute instances (control plane + workers) with attached block volumes for Longhorn.
- **Ansible** installs Tailscale (overlay mesh), then deploys k3s - control plane first (HA via `--cluster-init`), followed by workers. All node-to-node traffic goes over Tailscale (`flannel-iface=tailscale0`).
- **Infisical** injects Universal Auth credentials as a Kubernetes secret for the Infisical Operator.
- **ArgoCD** is bootstrapped on the first control plane node using the [k3s-gitops](https://github.com/NullMonkeys/k3s-gitops) repository (app-of-apps pattern), pulling the GitOps repo, applying the ArgoCD manifests, and deploying the root application.
- **Longhorn** block volumes are attached but must be configured in-cluster after bootstrap.

## Prerequisites

- [HCP Terraform](https://app.terraform.io) account
- [Oracle Cloud](https://cloud.oracle.com) account(s)
- [Tailscale](https://tailscale.com) account and pre-generated reusable auth key
- [Infisical](https://infisical.com) Client ID and Client Secret for Universal Auth
- Ansible 2.21+ (`ansible.posix`, `community.general`, `kubernetes.core`)

## Project structure

```
├── terraform/
│   ├── live/                    # Root module (HCP workspace)
│   └── modules/
│       ├── oci-network/         # VCN, subnet, security list
│       └── oci-compute/         # Instances + Longhorn volumes
├── ansible/
│   ├── ansible.cfg              # Ansible configuration (SSH key, plugins)
│   ├── inventory/
│   │   ├── hosts.toml
│   │   └── group_vars/all/
│   │       └── secrets.yaml.example
│   ├── playbooks/
│   │   └── site.yaml             # Main playbook
│   ├── requirements.yaml         # Ansible collection dependencies
│   └── roles/
│       ├── common/              # OS deps, disable IPv6/swap, mount Longhorn
│       ├── tailscale/           # Install & auth to Tailscale
│       ├── k3s_control_plane/   # Bootstrap/join control plane
│       ├── k3s_worker/          # Join workers
│       └── argocd/              # Bootstrap ArgoCD + Infisical secrets
└── .github/workflows/lint.yaml   # CI: Terraform fmt/validate + ansible-lint
```

## Secrets

Required variables in `ansible/inventory/group_vars/all/secrets.yaml`:

| Variable | Description |
|---|---|
| `k3s_token` | Shared k3s cluster token |
| `infisical_client_id` | Infisical Universal Auth client ID |
| `infisical_client_secret` | Infisical Universal Auth client secret |

## CI

Pull requests run `terraform fmt -check`, `terraform validate`, and `ansible-lint`.

## License

MIT - see [LICENSE](LICENSE)
