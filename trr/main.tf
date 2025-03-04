provider "vsphere" {
  user     = var.vc_username
  password = var.vc_password
  vsphere_server = var.vc_server

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {

}
data "vsphere_datastore" "datastore" {
  name          = var.vc_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vc_network
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "pool" {
  name          = var.vc_res_pool_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "create_cp" {
  source = "./create_cp"

  datacenter_id = data.vsphere_datacenter.dc.id
  datastore_id = data.vsphere_datastore.datastore.id
  network_id = data.vsphere_network.network.id
  image_name = var.vc_image
  pool_id = data.vsphere_resource_pool.pool.id
  vm_name = "k8scp"
  vm_domain = "local"
  vm_cpu = 4
  vm_mem = 4096

  vm_user = var.vm_user
  vm_password = var.vm_password
}

module "create_wrk" {
  source = "./create_wrk"

  datacenter_id = data.vsphere_datacenter.dc.id
  datastore_id = data.vsphere_datastore.datastore.id
  network_id = data.vsphere_network.network.id
  image_name = var.vc_image
  pool_id = data.vsphere_resource_pool.pool.id
  vm_name = "k8sworker"
  vm_domain = "local"
  vm_cpu = 4
  vm_mem = 8192

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

module "init_clu" {
  source = "./init_clu"

  vm_ip = module.create_cp.node_ip
  wrk_ip = module.create_wrk.node_ip

  vm_user = var.vm_user
  vm_password = var.vm_password
  pod_network = "172.16.0.0/16"
  calico_url = "https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests"
}