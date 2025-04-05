resource "azurerm_virtual_network" "brian_vn" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [ var.vnet_address_space ]

  tags = var.tags
}

resource "azurerm_subnet" "network_subnets" {
  count = var.vnet_subnet_count
  name = "subnet-${count.index}"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.brian_vn.name
  address_prefixes = [cidrsubnet(var.vnet_address_space,var.new_bits,count.index)]

  depends_on = [ azurerm_virtual_network.brian_vn ]
}