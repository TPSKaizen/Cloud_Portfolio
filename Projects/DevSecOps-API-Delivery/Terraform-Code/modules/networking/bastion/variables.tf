# Resource Group

variable "resource_group_name" {
  type = string
  description = "Name of Resource Group"
}

variable "resource_group_location" {
  type = string
  description = "Location of resource group"
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