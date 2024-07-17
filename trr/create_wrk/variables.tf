variable "datastore_name" {
  description = "VC datastore name"
  type        = string
}

variable "network_name" {
  description = "VC network name"
  type        = string
}

variable "image_name" {
  description = "VC image name"
  type        = string
}

variable "group_name" {
  description = "VC group name"
  type        = string
}

#######################################################################

variable "vcs_ip" {
  description = "VCenter server ip address"
  type        = string
}

variable "vm_name" {
  description = "VM's name"
  type        = string
}

variable "vm_domain" {
  description = "VM's domain"
  type        = string
}

variable "vm_cpu" {
  description = "VM's CPU number"
  type        = number
}

variable "vm_mem" {
  description = "VM's memory size"
  type        = number
}

#######################################################################

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