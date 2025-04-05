# # -------------------------- Central DNS Zone RG -------------------------- #

module "central_dns_zone_rg" {
  source                  = "./modules/general/resource_group"
  resource_group_location = "canada central"
  resource_group_name     = "central_dns_zone_rg"

  tags = {
    environment = "dev",
    purpose     = "Central DNS Zone Resource Group"
  }
}

# # -------------------------- Global DNS Zones -------------------------- #

module "container_registry_dns_zone" {
  #for_each = local.private_dns_zones

  source = "./modules/networking/private_dns_zone"

  resource_group_name = module.central_dns_zone_rg.rg.name

  private_dns_zone_name = "privatelink.azurecr.io"

  vnet_links = [
    {
      # Supporting Infra Vnet Link
      name               = "supporitng_infra_vnet_link"
      virtual_network_id = module.supporting_infra_vnet.virtual_network.id
    },
    {
      # Solution 1 Vnet Link
      name               = "solution1_vnet_link"
      virtual_network_id = module.solution1_vnet.virtual_network.id
    },
  ]

  tags = {
    environment = "dev"
  }

  depends_on = [module.supporting_infra_vnet, module.solution1_vnet]
}

module "key_vault_dns_zone" {

  source = "./modules/networking/private_dns_zone"

  resource_group_name = module.central_dns_zone_rg.rg.name

  private_dns_zone_name = "privatelink.vaultcore.azure.net"

  vnet_links = [
    {
      # Supporting Infra Vnet Link
      name               = "supporitng_infra_vnet_link"
      virtual_network_id = module.supporting_infra_vnet.virtual_network.id
    },
    {
      # Solution 1 Vnet Link
      name               = "solution1_vnet_link"
      virtual_network_id = module.solution1_vnet.virtual_network.id
    },
  ]

  tags = {
    environment = "dev"
  }

  depends_on = [module.supporting_infra_vnet, module.solution1_vnet]
}


# # -------------------------- SUPPORT INFRA -------------------------- #
module "support_infra_rg" {
  source                  = "./modules/general/resource_group"
  resource_group_location = "canada central"
  resource_group_name     = "support_infra_rg"

  tags = {
    environment = "dev",
    purpose     = "Support Infrastructure Resource Group"
  }
}

# Build Agent Networking
module "supporting_infra_vnet" {
  source = "./modules/networking/virtual_network"

  # Resource Group
  location            = module.support_infra_rg.rg.location
  resource_group_name = module.support_infra_rg.rg.name

  # Vnet
  vnet_name          = "supporting_infra_vnet"
  vnet_address_space = "10.0.0.0/24" # 251 ips
  new_bits           = 1
  tags = {
    environment = "dev"
  }
  # Subnet
  vnet_subnet_count = 1
}

# Bastion
module "bastion_test" {
  source = "./modules/networking/bastion"

  tags = {
    environment = "dev"
  }

  bastion_name            = "supporting_infra_bastion"
  bastion_sku             = "Developer"
  resource_group_location = module.support_infra_rg.rg.location
  resource_group_name     = module.support_infra_rg.rg.name
  vnet_id                 = module.supporting_infra_vnet.virtual_network.id

  depends_on = [module.supporting_infra_vnet]
}

module "nsg" {
  source                  = "./modules/networking/network_security_group"
  rg_name                 = module.support_infra_rg.rg.name
  resource_group_location = module.support_infra_rg.rg.location
  nsg_name                = "build_agent_nsg"
  subnet_id               = module.supporting_infra_vnet.subnets[0].id

  depends_on = [module.supporting_infra_vnet]
}

# Allow connectivity on port 9000 for SonarQube
module "nsg_rule" {
  source = "./modules/networking/network_security_rule"

  nsg_name                            = module.nsg.nsg.name
  nsg_resource_group_name             = module.support_infra_rg.rg.name
  nsg_rule_access                     = "Allow"
  nsg_rule_destination_address_prefix = "*"
  nsg_rule_destination_port           = "9000"
  nsg_rule_direction                  = "Inbound"
  nsg_rule_name                       = "allow_sonarqube_inbound"
  nsg_rule_priority                   = "310"
  nsg_rule_protocol                   = "Tcp"
  nsg_rule_source_address_prefix      = "*"
  nsg_rule_source_port                = "*"

  depends_on = [module.nsg]
}

# Build Agent UMI
module "build_agent_umi" {
  source      = "./modules/identity/user_managed_identity"
  rg_location = module.support_infra_rg.rg.location
  rg_name     = module.support_infra_rg.rg.name
  umi_name    = "buildagentumi"
  role_assignments = [
    {
      scope     = module.sol1_acr.acr.id
      role_name = "AcrPush"
    },
    {
      scope     = module.sol1_acr.acr.id
      role_name = "AcrPull"
    },
     {
      scope     = module.sol1_acr.acr.id
      role_name = "AcrDelete"
    },
    {
      scope     = module.sol1_acr.acr.id
      role_name = "Reader"
    },
  ]
  depends_on = [module.sol1_acr]
}


# Compute
module "linux_vm_build_agent" {
  source = "./modules/compute/linux_build_agent"


  # RG
  resource_group_name     = module.support_infra_rg.rg.name
  resource_group_location = module.support_infra_rg.rg.location

  # NIC
  nic_name = "linux_build_agent_vm_nic"

  #VNET
  subnet_id = module.supporting_infra_vnet.subnets[0].id

  # VM
  admin_username = ""
  admin_password = var.admin_password

  vm_name = "brianbuildagent"
  vm_size = "Standard_B4s_v2"

  # Extension Script
  azdo_org_url = ""
  azdo_pat     = var.azdo_pat
  azdo_pool    = ""

  # Identity
  identities = [
    {
      identity_type = "UserAssigned"
      identity_ids  = [module.build_agent_umi.umi.id]
    }
  ]

  tags = {
    environment = "dev"
  }

  depends_on = [module.support_infra_rg, module.supporting_infra_vnet, module.build_agent_umi]
}

module "interface_win_machine" {
  source = "./modules/compute/windows_vm"

  # RG
  resource_group_name     = module.support_infra_rg.rg.name
  resource_group_location = module.support_infra_rg.rg.location

  # NIC
  nic_name = "win_interace_vm_nic"

  # VNET
  subnet_id = module.supporting_infra_vnet.subnets[0].id

  # VM 
  vm_name = "wininterface"
  vm_size = "Standard_F8s_v2"

  # Authentication
  admin_password = var.admin_password
  admin_username = ""
}

# # -------------------------- Solution 1 INFRA -------------------------- #

module "solution1_rg" {
  source                  = "./modules/general/resource_group"
  resource_group_location = "canada central"
  resource_group_name     = "solution1_rg"

  tags = {
    environment = "dev",
    purpose     = "Solution Resource Group"
  }
}

module "solution1_vnet" {
  source = "./modules/networking/virtual_network"

  # Resource Group
  location            = module.solution1_rg.rg.location
  resource_group_name = module.solution1_rg.rg.name

  # Vnet
  vnet_name          = "solution1_vnet"
  vnet_address_space = "10.0.1.0/24" # 251 ips
  new_bits           = 1
  tags = {
    environment = "dev"
  }
  # Subnet
  vnet_subnet_count = 1
}

module "sol1_acr" {
  source = "./modules/registry/azure_container_registry"

  acr_name                    = "briantestregistry"
  acr_resource_group_name     = module.solution1_rg.rg.name
  acr_resource_group_location = module.solution1_rg.rg.location

}

module "acr_pe" {
  source = "./modules/networking/private_endpoint"

  resource_group_location = module.solution1_rg.rg.location
  resource_group_name     = module.solution1_rg.rg.name

  subnet_id = module.solution1_vnet.subnets[0].id
  vnet_id   = module.solution1_vnet.virtual_network.id

  private_endpoint_name = "sol1_acr_pe"

  private_service_connection_name     = "acr_private_endpoint_connection"
  private_connection_resource_id      = module.sol1_acr.acr.id
  private_connection_subresource_name = ["registry"]
  is_manual_connection                = false

  private_dns_zone_group_name = "azure_container_registries"
  private_dns_zone_ids        = [module.container_registry_dns_zone.dns_zone.id]

  tags = {
    environment = "dev"
  }

  depends_on = [module.sol1_acr, module.solution1_vnet, module.container_registry_dns_zone]
}

# # -------------------------- VNET LINKS -------------------------- #

module "support_infra_vnet_to_solution1_vnet" {
  source = "./modules/networking/vnet_peering"

  vnet_1_rg_name = module.support_infra_rg.rg.name
  vnet_2_rg_name = module.solution1_rg.rg.name

  vnet1_to_vnet2_peer_name = "support_infra_to_solution1"
  vnet2_to_vnet1_peer_name = "solution1_to_support_infra"

  vnet1_name = module.supporting_infra_vnet.virtual_network.name
  vnet2_name = module.solution1_vnet.virtual_network.name

  vnet1_id = module.supporting_infra_vnet.virtual_network.id
  vnet2_id = module.solution1_vnet.virtual_network.id

  depends_on = [module.supporting_infra_vnet, module.solution1_vnet]

}