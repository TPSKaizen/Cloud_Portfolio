## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.14.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_linux_vm_build_agent"></a> [linux\_vm\_build\_agent](#module\_linux\_vm\_build\_agent) | ./modules/compute/linux_build_agent | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ./modules/general/resource_group | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Linux VM Admin Password | `string` | n/a | yes |
| <a name="input_azdo_pat"></a> [azdo\_pat](#input\_azdo\_pat) | AZDO PAT | `string` | n/a | yes |

## Outputs

No outputs.
