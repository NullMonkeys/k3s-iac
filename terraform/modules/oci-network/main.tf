terraform {
  required_version = "~> 1.15.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.18.0"
    }
  }
}

resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  cidr_block     = var.vcn_cidr
  display_name   = var.vcn_name
  dns_label      = var.vcn_dns_label
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-igw"
  enabled        = true
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.vcn.id
  cidr_block        = var.vcn_cidr
  display_name      = "${var.vcn_name}-public-subnet"
  route_table_id    = oci_core_default_route_table.default_route_table.id
  security_list_ids = [oci_core_vcn.vcn.default_security_list_id]
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_default_security_list" "security_list" {
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id

  egress_security_rules {
    protocol    = "ALL"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol = "17"
    source   = "0.0.0.0/0"
    udp_options {
      min = 41641
      max = 41641
    }
  }
}
