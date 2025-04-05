provider "vsphere" {
  user     = var.vc_username
  password = var.vc_password
  vsphere_server = var.vc_params.server

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {}

data "vsphere_datastore" "datastore" {
  name          = var.vc_params.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vc_params.network
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "pool" {
  name          = var.vc_params.res_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "source_template" {
  name          = var.vc_params.image
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "k8s_vms" {
  for_each = var.vm_params
  name             = each.value.name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id = data.vsphere_virtual_machine.source_template.guest_id
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  num_cpus = each.value.cpu
  memory   = each.value.memory
  disk {
    label = "disk0"
    size = data.vsphere_virtual_machine.source_template.disks[0].size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.source_template.id
    customize {
      linux_options {
        host_name = each.value.name
        domain    = each.value.domain
      }
      network_interface {
        ipv4_address = each.value.ip
        ipv4_netmask = each.value.mask
      }
      ipv4_gateway = each.value.gateway
      dns_server_list = each.value.dns
    }
  }
}