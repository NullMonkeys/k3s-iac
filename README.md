Cross-region k3s cluster on Oracle Cloud Infrastructure, provisioned with Terraform (HCP) and configured with Ansible.

> **Disclaimer:** This is an internal setup. It requires HCP Terraform and manual Ansible inventory management. You probably shouldn't use it :)

## Architecture

- **Terraform** provisions OCI network (VCN, subnet, security list) and compute instances (control plane + workers) with attached block volumes for Longhorn.
- **Ansible** installs Tailscale (overlay mesh), then deploys k3s — control plane first (HA via `--cluster-init`), followed by workers. All node-to-node traffic goes over Tailscale (`flannel-iface=tailscale0`).
- **Longhorn** block volumes are attached but must be configured in-cluster after bootstrap.

## Prerequisites

- [HCP Terraform](https://app.terraform.io) account
- [Oracle Cloud](https://cloud.oracle.com) account(s)
- [Tailscale](https://tailscale.com) account and pre-generated reusable auth key
- Ansible 2.15+ (`ansible.posix`, `community.general`)

## Project structure

```
├── terraform/
│   ├── live/                    # Root module (HCP workspace)
│   └── modules/
│       ├── oci-network/         # VCN, subnet, security list
│       └── oci-compute/         # Instances + Longhorn volumes
├── ansible/
│   ├── inventory/
│   │   ├── hosts.toml           # Manual IP assignments
│   │   └── group_vars/all/
│   │       └── secrets.yml.example
│   ├── playbooks/
│   │   └── site.yml             # Main playbook
│   └── roles/
│       ├── common/              # OS deps, disable IPv6/swap, mount Longhorn
│       ├── tailscale/           # Install & auth to Tailscale
│       ├── k3s_control_plane/   # Bootstrap/join control plane
│       └── k3s_worker/          # Join workers
└── .github/workflows/lint.yml   # CI: Terraform fmt/validate + ansible-lint
```

## CI

Pull requests run `terraform fmt -check`, `terraform validate`, and `ansible-lint`.

## License

Apache 2.0 — see [LICENSE](LICENSE)
