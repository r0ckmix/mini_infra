resource "null_resource" "vm_configuration_linux" {
  connection {
    type     = "ssh"
    user     = var.vm_user
    password = var.vm_password
    host     = var.vm_ip
  }
  provisioner "file" {
    source      = "k8s_clu_init.sh"
    destination = "/tmp/k8s_clu_init.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k8s_clu_init.sh",
      "export CALICO_URL=${var.calico_url} && export POD_NETWORK=${var.pod_network} && /tmp/k8s_clu_init.sh"
    ]
  }

  provisioner "file" {
    source      = "k8s_add_host.sh"
    destination = "/tmp/k8s_add_host.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k8s_add_host.sh",
      "export K8S_USER=${var.vm_user} && export K8S_PASS=${var.vm_password} && WRK_IP=${var.wrk_ip} && /tmp/k8s_add_host.sh"
    ]
  }
}