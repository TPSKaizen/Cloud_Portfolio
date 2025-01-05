# This variables files exists for passing sensitive information to modules

variable "admin_password" {
  type = string
  description = "Linux VM Admin Password"
  sensitive = true
}

variable "azdo_pat" {
  type = string
  description = "AZDO PAT"
  sensitive = true
}