terraform {
  required_version = "~> 1.15.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.24.0"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_core_instance" "instance" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  count        = var.node_count
  shape        = var.node_shape
  display_name = "${var.node_name_prefix}-${count.index + 1}"

  shape_config {
    ocpus         = var.node_ocpus
    memory_in_gbs = var.node_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    assign_ipv6ip    = false
  }

  source_details {
    source_type             = "image"
    source_id               = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaal4itgbo25fulz7jbwyjdk2qc775l4npiqraf44ac62pf4iqfddsa"
    boot_volume_size_in_gbs = var.node_boot_volume_size_in_gbs
  }

  metadata = {
    "ssh_authorized_keys" = var.ssh_public_key
  }
}


resource "oci_core_volume" "longhorn_volume" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  count        = var.node_longhorn_volume_size_in_gbs > 50 ? var.node_count : 0
  size_in_gbs  = var.node_longhorn_volume_size_in_gbs
  display_name = "${var.node_name_prefix}-${count.index + 1}-longhorn"
}

resource "oci_core_volume_attachment" "longhorn_volume_attachment" {
  instance_id = oci_core_instance.instance[count.index].id
  volume_id   = oci_core_volume.longhorn_volume[count.index].id

  count           = var.node_longhorn_volume_size_in_gbs > 50 ? var.node_count : 0
  attachment_type = "PARAVIRTUALIZED"
}
