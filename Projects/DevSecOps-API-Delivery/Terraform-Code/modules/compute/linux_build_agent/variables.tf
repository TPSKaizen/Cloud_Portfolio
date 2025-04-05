# NIC
variable "nic_name" {
  type = string
  description = "Name of VM NIC"
}

#VM
variable "vm_name" {
  type = string
  description = "Name of VM"
}

variable "vm_size" {
  type = string
  description = "Size of VM"
}

# VNET

variable "subnet_id" {
  type = string
  description = "Subnet ID NIC will reside in"
}


variable "resource_group_name" {
  type = string
  description = "Resource Group Name"
}

variable "resource_group_location" {
  type = string
  description = "Resource Group Location"
}

variable "admin_username" {
  type = string
  description = "VM Admin Username"
}

variable "admin_password" {
  type = string
  description = "VM Admin Password"
  sensitive = true
}

# Virtual Machine Extension Script

variable "azdo_pat" {
  type = string
  description = "AZDO Pat"
}

variable "azdo_org_url" {
   type = string
   description = "AZDO Org Url"
}

variable "azdo_pool" {
   type = string
   description = "AZDO Pool"
}

# Identities

variable "identities" {
  type = list(object({
    identity_type = string
    identity_ids  = optional(list(string), [])
  }))
  default = []
}

# Tags

variable "tags" {
  type = object({
    environment = string
  })
}