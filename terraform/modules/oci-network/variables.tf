variable "compartment_id" {
  type        = string
  description = "OCID of the compartment to create the network in"
}

variable "vcn_cidr" {
  type        = string
  description = "CIDR block for the VCN. Defaults to 10.0.0.0/16"
  default     = "10.0.0.0/16"
}

variable "vcn_name" {
  type        = string
  description = "Name of the VCN. Defaults to 'k3s'"
  default     = "k3s"
}

variable "vcn_dns_label" {
  type        = string
  description = "DNS label for the VCN. Defaults to 'k3s'"
  default     = "k3s"
}
