resource "azurerm_virtual_network_peering" "peer_vnet1_to_vnet2" {
  name                      = var.vnet1_to_vnet2_peer_name
  resource_group_name       = var.vnet_1_rg_name
  virtual_network_name      = var.vnet1_name
  remote_virtual_network_id = var.vnet2_id
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "peer_vnet2_to_vnet1" {
  name                      = var.vnet2_to_vnet1_peer_name
  resource_group_name       = var.vnet_2_rg_name
  virtual_network_name      = var.vnet2_name
  remote_virtual_network_id = var.vnet1_id
  allow_forwarded_traffic = true
}