resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [cidrsubnet(var.vnet_prefix,var.bastion_new_bits,var.bastion_netnum)]
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku = var.bastion_sku
  virtual_network_id = var.vnet_id

  tags = var.tags

  depends_on = [ azurerm_subnet.bastion_subnet ]
}