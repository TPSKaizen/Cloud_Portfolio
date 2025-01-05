output "vm" {
  value = azurerm_linux_virtual_machine.build_agent_vm
}

output "linux_build_agent_vnet" {
  value = module.build_agent_virtual_network
}