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