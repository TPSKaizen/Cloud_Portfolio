output "virtual_network" {
    value = azurerm_virtual_network.brian_vn
}

output "subnets" {
    value = azurerm_subnet.network_subnets[*] # All subnets created
}