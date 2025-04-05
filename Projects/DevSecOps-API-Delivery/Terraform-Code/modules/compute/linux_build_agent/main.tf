resource "azurerm_network_interface" "build_agent_vm_nic" {
  name                = var.nic_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     =  var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "build_agent_vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

 dynamic "identity" {
  for_each = var.identities

  content {
    type         = identity.value.identity_type
    identity_ids = identity.value.identity_ids
  }
}

  network_interface_ids = [
    azurerm_network_interface.build_agent_vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 50
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  
  depends_on = [ azurerm_network_interface.build_agent_vm_nic ]
}

resource "azurerm_virtual_machine_extension" "build_agent_vm_custom_extension_script" {
  name                 = azurerm_linux_virtual_machine.build_agent_vm.name
  virtual_machine_id   = azurerm_linux_virtual_machine.build_agent_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  tags = var.tags

  settings = <<SETTINGS
 {
  "script": "${base64encode(local.custom_script_content)}"
 }
SETTINGS

depends_on = [ azurerm_linux_virtual_machine.build_agent_vm ]
}