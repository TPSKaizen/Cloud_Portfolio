variable "nsg_rule_name" {
  type = string
  description = "Name of NSG Rule"
}

variable "nsg_rule_priority" {
  type = number
  description = "Priority of NSG rule"
}

variable "nsg_rule_direction" {
  type = string
  description = "NSG rule direction"
}

variable "nsg_rule_access" {
  type = string
  description = "NSG rule access"
}

variable "nsg_rule_protocol" {
  type = string
  description = "NSG rule protocol"
}

variable "nsg_rule_source_port" {
  type = string
  description = "NSG rule source port"
}

variable "nsg_rule_destination_port" {
  type = string
  description = "NSG rule destination port"
}

variable "nsg_rule_source_address_prefix" {
  type = string
  description = "NSG rule source address prefix"
}

variable "nsg_rule_destination_address_prefix" {
  type = string
  description = "NSG rule destination address prefix"
}

variable "nsg_resource_group_name" {
  type = string
  description = "Resource group name where NSG resides"
}

variable "nsg_name" {
  type = string
  description = "Name of NSG that the rule will be associated with"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {}
}


