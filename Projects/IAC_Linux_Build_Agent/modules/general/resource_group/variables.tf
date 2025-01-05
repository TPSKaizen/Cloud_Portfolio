variable "resource_group_name" {
  type = string
  description = "Name of resource group"
}

variable "resource_group_location" {
  type = string
  description = "Location of resource group"
}

variable "tags" {
  type = object({
    environment = string
  })
}