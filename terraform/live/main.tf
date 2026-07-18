terraform {
  required_version = "~> 1.15.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.23.0"
    }
  }

  cloud {
    organization = "NullMonkeys"
    workspaces {
      project = "oci-k3s-cluster"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = var.region
}

module "network" {
  source = "../modules/oci-network"

  compartment_id = var.tenancy_ocid
  vcn_cidr       = var.vcn_cidr
  vcn_name       = var.vcn_name
  vcn_dns_label  = var.vcn_dns_label
}

module "control-plane" {
  source = "../modules/oci-compute"

  compartment_id = var.tenancy_ocid
  subnet_id      = module.network.subnet_id

  ssh_public_key                   = var.ssh_public_key
  operating_system                 = var.operating_system
  operating_system_version         = var.operating_system_version
  node_shape                       = var.node_shape
  node_count                       = var.control_plane_count
  node_name_prefix                 = "${var.node_name_prefix}-control-plane"
  node_ocpus                       = var.node_ocpus
  node_memory_in_gbs               = var.node_memory_in_gbs
  node_boot_volume_size_in_gbs     = var.node_boot_volume_size_in_gbs
  node_longhorn_volume_size_in_gbs = var.node_longhorn_volume_size_in_gbs
}

module "workers" {
  source = "../modules/oci-compute"

  compartment_id = var.tenancy_ocid
  subnet_id      = module.network.subnet_id

  ssh_public_key                   = var.ssh_public_key
  operating_system                 = var.operating_system
  operating_system_version         = var.operating_system_version
  node_shape                       = var.node_shape
  node_count                       = var.worker_count
  node_name_prefix                 = "${var.node_name_prefix}-worker"
  node_ocpus                       = var.node_ocpus
  node_memory_in_gbs               = var.node_memory_in_gbs
  node_boot_volume_size_in_gbs     = var.node_boot_volume_size_in_gbs
  node_longhorn_volume_size_in_gbs = var.node_longhorn_volume_size_in_gbs
}

output "control_plane_public_ips" {
  value = module.control-plane.public_ips
}

output "worker_public_ips" {
  value = module.workers.public_ips
}

output "public_ips" {
  value = concat(module.control-plane.public_ips, module.workers.public_ips)
}
