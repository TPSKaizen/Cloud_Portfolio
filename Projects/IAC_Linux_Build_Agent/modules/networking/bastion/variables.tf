# Resource Group

variable "resource_group_name" {
  type = string
  description = "Name of Resource Group"
}

variable "resource_group_location" {
  type = string
  description = "Location of resource group"
}

# Networking

variable "virtual_network_name" {
  type = string
  description = "Name of Virtual Network"
}

variable "vnet_prefix" {
  type = string
  description = "Address prefix of bastion subnet"
}

# Bastion

variable "bastion_name" {
  type = string
  description = "Name of bastion"
}

variable "bastion_sku" {
  type = string
  description = "Bastion SKU"
}

variable "bastion_netnum" {
  type = number
  description = "Bastion net number for subnet"
}

variable "bastion_new_bits" {
  type = number
  description = "Bastion new bits for subnet"
}

# Tags

variable "tags" {
  type = object({
    environment = string
  })
}

variable "vnet_id" {
  type = string
  description = "VNET Id"
}