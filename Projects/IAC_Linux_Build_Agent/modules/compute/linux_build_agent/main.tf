# VM will need a subnet to live in for the NIC

module "build_agent_virtual_network" {
  # Subnet created should be 10.0.0.1/28 which should have 16 usable address (Minus 5 for Azure?)
  source = "../../networking/virtual_network"
  vnet_name = "build_agents_vnet"
  vnet_address_space = "10.0.0.0/24"
  vnet_subnet_count = 1
  new_bits = 4

  location = var.resource_group_location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

module "bastion" {
  source = "../../networking/bastion"

  # Resource Group
  resource_group_location = var.resource_group_location
  resource_group_name = var.resource_group_name

  # Vnet
  virtual_network_name = module.build_agent_virtual_network.virtual_network.name
  vnet_prefix = one(module.build_agent_virtual_network.virtual_network.address_space)
  vnet_id = module.build_agent_virtual_network.virtual_network.id
  bastion_netnum = 1
  bastion_new_bits = 4

  # Bastion
  bastion_sku = "Developer"
  bastion_name = "build_agent_bastion"

   tags = {
    environment = "dev"
  }
    depends_on = [ module.build_agent_virtual_network ]
}

resource "azurerm_network_interface" "build_agent_vm_nic" {
  name                = var.nic_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.build_agent_virtual_network.subnets[0].id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ module.build_agent_virtual_network ]
}

resource "azurerm_linux_virtual_machine" "build_agent_vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

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
