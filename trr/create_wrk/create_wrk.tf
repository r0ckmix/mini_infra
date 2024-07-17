provider "vsphere" {
  user     = var.vc_username
  password = var.vc_password
  vsphere_server = var.vcs_ip
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "source_template" {
  name          = var.image_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" k8s_wrk {
  name             = var.vm_name
  resource_pool_id = var.group_name
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id = data.vsphere_virtual_machine.source_template.guest_id

  num_cpus = var.vm_cpu
  memory   = var.vm_mem
  disk {
    label = "disk0"
    size = data.vsphere_virtual_machine.source_template.disks[0].size
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.source_template.id
    customize {
      linux_options {
        host_name = var.vm_name
        domain    = var.vm_domain
      }
      network_interface {}
    }
  }

  connection {
    type     = "ssh"
    user     = var.vm_user
    password = var.vm_password
    host     = self.guest_ip_addresses[0]
  }
  provisioner "file" {
    source      = "k8s_adm_install.sh"
    destination = "/tmp/k8s_adm_install.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k8s_adm_install.sh",
      "/tmp/k8s_adm_install.sh"
    ]
  }
}