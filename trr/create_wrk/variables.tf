variable "datacenter_id" {
  description = "VC datacenter ID"
  type        = string
}

variable "datastore_id" {
  description = "VC datastore ID"
  type        = string
}

variable "network_id" {
  description = "VC network ID"
  type        = string
}

variable "image_name" {
  description = "VC image name"
  type        = string
}

variable "pool_id" {
  description = "VC pool ID"
  type        = string
}

#######################################################################

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