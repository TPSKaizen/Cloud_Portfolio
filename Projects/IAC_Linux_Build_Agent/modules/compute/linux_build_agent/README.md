## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../../networking/bastion | n/a |
| <a name="module_build_agent_virtual_network"></a> [build\_agent\_virtual\_network](#module\_build\_agent\_virtual\_network) | ../../networking/virtual_network | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.build_agent_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.build_agent_vm_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_extension.build_agent_vm_custom_extension_script](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | VM Admin Password | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | VM Admin Username | `string` | n/a | yes |
| <a name="input_azdo_org_url"></a> [azdo\_org\_url](#input\_azdo\_org\_url) | AZDO Org Url | `string` | n/a | yes |
| <a name="input_azdo_pat"></a> [azdo\_pat](#input\_azdo\_pat) | AZDO Pat | `string` | n/a | yes |
| <a name="input_azdo_pool"></a> [azdo\_pool](#input\_azdo\_pool) | AZDO Pool | `string` | n/a | yes |
| <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name) | Name of VM NIC | `string` | n/a | yes |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Resource Group Location | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | <pre>object({<br/>    environment = string<br/>  })</pre> | n/a | yes |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Name of VM | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Size of VM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_linux_build_agent_vnet"></a> [linux\_build\_agent\_vnet](#output\_linux\_build\_agent\_vnet) | n/a |
| <a name="output_vm"></a> [vm](#output\_vm) | n/a |
