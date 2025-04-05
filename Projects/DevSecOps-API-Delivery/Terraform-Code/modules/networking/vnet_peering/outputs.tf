output "vnet1_vnet2_link" {
  value = azurerm_virtual_network_peering.peer_vnet1_to_vnet2
}

output "vnet2_vnet1_link" {
  value = azurerm_virtual_network_peering.peer_vnet2_to_vnet1
}