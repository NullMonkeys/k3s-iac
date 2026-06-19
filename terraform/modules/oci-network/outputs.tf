output "subnet_id" {
  value       = oci_core_subnet.public_subnet.id
  description = "The ID of the public subnet where k3s nodes will be deployed"
}
