output "node_name" {
  description = "node_name"
  value       = vsphere_virtual_machine.k8s_wrk.name
}

output "node_ip" {
  description = "node_ip"
  value       = vsphere_virtual_machine.k8s_wrk.default_ip_address
}

output "node_domain" {
  description = "node_domain"
  value       = var.vm_domain
}