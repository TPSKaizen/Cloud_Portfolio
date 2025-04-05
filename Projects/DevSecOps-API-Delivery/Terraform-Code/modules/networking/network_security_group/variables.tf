variable "nsg_name" {
  type = string
  description = "Name of NSG"
}

variable "rg_name" {
  type = string
  description = "Name of RG"
}

variable "resource_group_location" {
  type = string
  description = "Name of RG Location"
}

variable "subnet_id" {
  type = string
  description = "The ID of the Subnet. Changing this forces a new resource to be created"
}