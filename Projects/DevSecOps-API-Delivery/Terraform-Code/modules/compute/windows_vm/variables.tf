# NIC
variable "nic_name" {
  type = string
  description = "Name of VM NIC"
}

variable "subnet_id" {
  type = string
  description = "Subnet ID NIC will reside in"
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