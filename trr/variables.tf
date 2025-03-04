variable "vc_datastore" {
  type        = string
  default     = "bddt1"
}

variable "vc_network" {
  type        = string
  default     = "VM Network"
}

variable "vc_image" {
  type        = string
  default     = "k8s_img"
}

variable "vc_server" {
  type        = string
  default     = "192.168.0.2"
}

variable "vc_res_pool_name" {
  type        = string
  default     = "192.168.0.5/Resources"
}

variable "vc_username" {
  description = "VCenter administrator username"
  type        = string
  sensitive   = true
}

variable "vc_password" {
  description = "VCenter administrator password"
  type        = string
  sensitive   = true
}

variable "vm_user" {
  description = "VM user name"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "VM user password"
  type        = string
  sensitive   = true
}