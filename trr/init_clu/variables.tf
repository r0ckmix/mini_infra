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

variable "vm_ip" {
  description = "VM user password"
  type        = string
}

variable "pod_network" {
  description = "Pod network IP range"
  type        = string
}

variable "calico_url" {
  description = "Calico project source url"
  type        = string
}

#=========================================================

variable "wrk_ip" {
  type        = string
}