module "create_cp" {
  source = "./create_cp"

  datastore_name = "large_ds"
  network_name = "VM Network"
  image_name = "k8s_img"
  group_name = "resgroup-8"
  vcs_ip = "192.168.0.204"
  vm_name = "k8scp"
  vm_domain = "local"
  vm_cpu = 4
  vm_mem = 4096

  vc_username = var.vc_username
  vc_password = var.vc_password
  vm_user = var.vm_user
  vm_password = var.vm_password
}

module "create_wrk" {
  source = "./create_wrk"

  datastore_name = "large_ds"
  network_name = "VM Network"
  image_name = "k8s_img"
  group_name = "resgroup-8"
  vcs_ip = "192.168.0.204"
  vm_name = "k8sworker"
  vm_domain = "local"
  vm_cpu = 4
  vm_mem = 8192

  vc_username = var.vc_username
  vc_password = var.vc_password
  vm_user = var.vm_user
  vm_password = var.vm_password
}



module "edit_cp" {
  source = "./edit_vm"

  cp_ip = module.create_cp.node_ip
  cp_name = module.create_cp.node_name
  cp_domain = module.create_cp.node_domain
  wrk_ip = module.create_wrk.node_ip
  wrk_name = module.create_wrk.node_name
  wrk_domain = module.create_wrk.node_domain

  vm_ip = module.create_cp.node_ip

  vm_user = var.vm_user
  vm_password = var.vm_password
}

module "edit_wrk" {
  source = "./edit_vm"

  cp_ip = module.create_cp.node_ip
  cp_name = module.create_cp.node_name
  cp_domain = module.create_cp.node_domain
  wrk_ip = module.create_wrk.node_ip
  wrk_name = module.create_wrk.node_name
  wrk_domain = module.create_wrk.node_domain

  vm_ip = module.create_wrk.node_ip

  vm_user = var.vm_user
  vm_password = var.vm_password
}