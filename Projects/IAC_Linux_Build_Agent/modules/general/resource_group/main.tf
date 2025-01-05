resource "azurerm_resource_group" "brian_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = var.tags
}