variable "vm_params" {
  type = map(any)
  default = {
    k8scp = {
      name = "k8scp"
      domain = "local"
      cpu = 4
      memory = 4096
      ip = "192.168.0.3"
      mask = 24
      gateway = "192.168.0.1"
      dns = ["8.8.8.8"]
    },
    k8swrk = {
      name = "k8sworker"
      domain = "local"
      cpu = 4
      memory = 8192
      ip = "192.168.0.4"
      mask = 24
      gateway = "192.168.0.1"
      dns = ["8.8.8.8"]
    }
  }
}

variable "vc_params" {
  type = object({
    datastore = string
    network = string
    image = string
    server = string
    res_pool = string
  })
  default = {
    datastore = "bddt1"
    network = "VM Network"
    image = "k8s_img"
    server = "192.168.0.2"
    res_pool = "192.168.0.5/Resources"
  }
}

variable "vc_username" {
  description = "VCenter administrator username"
  type        = string
}

variable "vc_password" {
  description = "VCenter administrator password"
  type        = string
  sensitive   = true
}

variable "vm_user" {
  description = "VM user name"
  type        = string
}

variable "vm_password" {
  description = "VM user password"
  type        = string
  sensitive   = true
}