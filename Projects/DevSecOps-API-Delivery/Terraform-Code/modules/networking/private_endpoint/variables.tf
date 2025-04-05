# General

variable "resource_group_name" {
  type = string
  description = " Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
}

variable "resource_group_location" {
  type = string
  description = "The supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

# Network Related

variable "vnet_id" {
type = string
description = "ID of Vnet to link to Private DNS Zones"
}

variable "subnet_id" {
type = string
description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
}

# Private Endpoint

variable "private_endpoint_name" {
  type = string
  description = "Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
}

variable "private_service_connection_name" {
  type = string
  description = "Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created."
}

variable "private_connection_resource_id" {
  type = string
  description = "The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to."
  # Example : storage account id, container registry id etc..
}

variable "private_connection_subresource_name" {
  type = list(string)
  description = "A list of subresource names which the Private Endpoint is able to connect to"
}

variable "private_dns_zone_group_name" {
  type = string
  description = "Specifies the Name of the Private DNS Zone Group."
}

variable "private_dns_zone_ids" {
    type = list(string)
    description = "Specifies the list of Private DNS Zones to include within the private_dns_zone_group"
}

variable "is_manual_connection" {
    type = bool
    default = false
    description = "Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created."
}

# Tags

variable "tags" {
  type = object({
    environment = string
  })
}