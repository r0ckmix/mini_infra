data "vsphere_virtual_machine" "source_template" {
  name          = var.image_name
  datacenter_id = var.datacenter_id
}

resource "vsphere_virtual_machine" "k8s_wrk" {
  name             = var.vm_name
  resource_pool_id = var.pool_id
  datastore_id     = var.datastore_id
  guest_id = data.vsphere_virtual_machine.source_template.guest_id

  num_cpus = var.vm_cpu
  memory   = var.vm_mem
  disk {
    label = "disk0"
    size = data.vsphere_virtual_machine.source_template.disks[0].size
  }

  network_interface {
    network_id = var.network_id
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