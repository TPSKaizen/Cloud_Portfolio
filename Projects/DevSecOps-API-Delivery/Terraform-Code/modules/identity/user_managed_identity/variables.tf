variable "rg_location" {
   type = string
   description = "Resource group location"
}

variable "rg_name" {
   type = string
  description = "Resource group name"
}

variable "umi_name" {
   type = string
  description = "UMI name"
}

variable "role_assignments" {
    type = list(object({
      scope = string
      role_name = string
    })) 

    description = "List of role assignments to apply to UMI"
}