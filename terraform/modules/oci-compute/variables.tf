variable "compartment_id" {
  type        = string
  description = "OCID of the compartment to create the network in"
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet to create the compute instance in"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for the compute instance"
}

variable "operating_system_image_id" {
  type        = string
  default     = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaal4itgbo25fulz7jbwyjdk2qc775l4npiqraf44ac62pf4iqfddsa"
  description = "OCID of the operating system image to use for compute instances. Defaults to Canonical Ubuntu 24.04 (Frankfurt-1)"
}

variable "node_shape" {
  type        = string
  description = "Shape of the compute instance (e.g., VM.Standard.A1.Flex, VM.Standard.E4.Flex)"
  default     = "VM.Standard.A1.Flex"
}

variable "node_count" {
  type        = number
  description = "Number of compute instances to create"
  default     = 1
}

variable "node_name_prefix" {
  type        = string
  description = "Prefix for the name of the compute instance"
}

variable "node_ocpus" {
  type        = number
  description = "Number of OCPUs for the compute instance"
  default     = 2
}

variable "node_memory_in_gbs" {
  type        = number
  description = "Memory in GB for the compute instance"
  default     = 12
}

variable "node_boot_volume_size_in_gbs" {
  type        = number
  description = "Boot volume size in GB for the compute instance"
  default     = 50

  validation {
    condition     = var.node_boot_volume_size_in_gbs >= 50
    error_message = "Boot volume size must be at least 50 GB"
  }
}

variable "node_longhorn_volume_size_in_gbs" {
  type        = number
  description = "Longhorn volume size in GB for the compute instance"
  default     = 150
}
