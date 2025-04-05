resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku = var.bastion_sku
  virtual_network_id = var.vnet_id

  tags = var.tags
}