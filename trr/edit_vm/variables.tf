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

#=========================================================

variable "cp_ip" {
  type        = string
}
variable "cp_name" {
  type        = string
}
variable "wrk_ip" {
  type        = string
}
variable "wrk_name" {
  type        = string
}
variable "cp_domain" {
  type        = string
}
variable "wrk_domain" {
  type        = string
}