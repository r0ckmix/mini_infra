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
    image = "gimage"
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
  description = "VM password"
  type        = string
  sensitive   = true
}

variable "calico_url" {
  type        = string
  default     = "https://raw.githubusercontent.com/projectcalico/calico/v3.30.0/manifests"
}

variable "helm_url" {
  type        = string
  default     = "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"
}

variable "pod_network" {
  type        = string
  default     = "172.16.0.0/16"
}

variable "metallb_pool" {
  type        = string
  default     = "192.168.0.210-192.168.0.220"
}