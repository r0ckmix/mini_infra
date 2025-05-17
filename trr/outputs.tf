# output "node_name" {
#   description = "node_name"
#   value       = vsphere_virtual_machine.k8s_cp.name
# }
#
# output "node_ip" {
#   description = "node_ip"
#   value       = vsphere_virtual_machine.k8s_vms[].default_ip_address
# }
#
# output "node_domain" {
#   description = "node_domain"
#   value       = var.vm_domain
# }
#
# output "vm_ip" {
#   value = {
#     for instance in vsphere_virtual_machine.k8s_vms:
#     instance.default_ip_address => instance
#   }
# }
#
# output "name" {
#   value = { for k, group in azurerm_resource_group.resource_group: k => group.name }
# }

# value = { for k, v in var.environments : v => azurerm_resource_group.resource_group[k].id }
