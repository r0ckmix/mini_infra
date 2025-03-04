resource "null_resource" "vm_configuration_linux" {
  connection {
    type     = "ssh"
    user     = var.vm_user
    password = var.vm_password
    host     = var.vm_ip
  }
  provisioner "file" {
    source      = "addhost.py"
    destination = "/tmp/addhost.py"
  }

  provisioner "remote-exec" {
    inline = [
      "python /tmp/addhost.py ${var.cp_ip} ${var.cp_name} ${var.cp_domain} ${var.wrk_ip} ${var.wrk_name} ${var.wrk_domain}"
    ]
  }
}