# General

variable "resource_group_name" {
  type = string
  description = " Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
}

# Private DNS Zone

variable "private_dns_zone_name" {
  type = string
  description = "Specifies the Name of the Private DNS Zone."
}

# Private DNS Zone VNET Link

variable "vnet_links" {
  description = "List of VNets to link to the private DNS zone"
  type = list(object({
    name                = string
    virtual_network_id  = string
  }))
}

# Tags
variable "tags" {
  type = object({
    environment = string
  })
}