variable "acr_name" {
  type = string
  description = "Name of the ACR"
}

variable "acr_resource_group_name" {
  type = string
  description = "Name of Resource Group that ACR resides in"
}

variable "acr_resource_group_location" {
  type = string
  description = "Location of Resource Group that ACR resides in"
}