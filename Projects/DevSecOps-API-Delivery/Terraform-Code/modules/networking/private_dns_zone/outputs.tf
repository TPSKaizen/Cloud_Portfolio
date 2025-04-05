output "dns_zone" {
  description = "DNS Zone Object"
  value = azurerm_private_dns_zone.zone
}

output "vnet_link" {
  description = "Vnet Link Object"
  value = azurerm_private_dns_zone_virtual_network_link.vnet_link
}