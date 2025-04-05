resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
  location            = var.acr_resource_group_location
  sku                 = "Premium"
  admin_enabled       = false
  public_network_access_enabled = false
}