# Resource Group

variable "resource_group_name" {
  type = string
  description = "Name of Resource Group"
}

variable "location" {
  type = string
  description = "Location of resource group"
}

# Virtual Network
variable "vnet_name" {
  type = string
  description = "Name of virtual network"
}

variable "vnet_address_space" {
  type = string
  description = "Address Space of Virtual Network"
}

variable "new_bits" {
  type = number
  description = "New bits for the cidrsubnet function"
}

# Tags

variable "tags" {
  type = object({
    environment = string
  })
}

# Subnet

variable "vnet_subnet_count" {
  type = number
  description = "value"
}