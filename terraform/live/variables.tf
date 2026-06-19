variable "tenancy_ocid" {
  type        = string
  description = "Compartment (Tenancy) OCID"
}

variable "user_ocid" {
  type        = string
  description = "User OCID"
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint of the user's key pair"
  sensitive   = true
}

variable "private_key" {
  type        = string
  description = "Private key of the user's key pair"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region where the resources will be created"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the compute instances"
}

variable "vcn_cidr" {
  type        = string
  description = "CIDR block for the VCN"
  default     = "10.0.0.0/16"
}

variable "vcn_name" {
  type        = string
  description = "Name of the VCN"
  default     = "k3s"
}

variable "vcn_dns_label" {
  type        = string
  description = "DNS label for the VCN"
  default     = "k3s"
}

variable "operating_system" {
  type        = string
  description = "Name of the operating system to use for compute instances"
  default     = "Canonical Ubuntu"
}

variable "operating_system_version" {
  type        = string
  description = "Version of the operating system to use for compute instances"
  default     = "24.04"
}

variable "control_plane_count" {
  type        = number
  description = "Number of control plane instances to create"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of worker instances to create"
  default     = 1
}

variable "node_shape" {
  type        = string
  description = "Shape of the compute instance"
  default     = "VM.Standard.A1.Flex"
}

variable "node_name_prefix" {
  type        = string
  description = "Prefix for compute instance display names. Final format: `{prefix}-{role}-{index} (e.g. k3s-node-control-plane-1)`"
  default     = "k3s-node"
}

variable "node_ocpus" {
  type        = number
  description = "Number of OCPUs for each compute instance"
  default     = 4
}

variable "node_memory_in_gbs" {
  type        = number
  description = "Memory (GB) for each compute instance"
  default     = 24
}

variable "node_boot_volume_size_in_gbs" {
  type        = number
  description = "Boot volume size (GB) for each compute instance"
  default     = 50
}

variable "node_longhorn_volume_size_in_gbs" {
  type        = number
  description = "Longhorn data volume size (GB) for each compute instance"
  default     = 150
}
