module "resource_group" {
  source = "./modules/general/resource_group"
  resource_group_location = "Central US"
  resource_group_name = "brian-rg"

  tags = {
    environment = "dev"
  }
}

module "linux_vm_build_agent" {
  source = "./modules/compute/linux_build_agent"

  # RG
  resource_group_name = module.resource_group.resource_group.name
  resource_group_location = module.resource_group.resource_group.location
  
  # NIC
  nic_name = ""

  # VM
  admin_username = ""
  admin_password = var.admin_password

  vm_name = ""
  vm_size = ""

  # Extension Script
  azdo_org_url = "<Your Azure DevOps Org Url"
  azdo_pat = var.azdo_pat
  azdo_pool = "<Your Azure DevOps Pool>"

  tags = {
    environment = "dev"
  }
}