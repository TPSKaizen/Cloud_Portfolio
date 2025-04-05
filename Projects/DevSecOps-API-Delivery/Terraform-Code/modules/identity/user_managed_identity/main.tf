resource "azurerm_user_assigned_identity" "umi" {
  location            = var.rg_location
  name                = var.umi_name    
  resource_group_name = var.rg_name
}

resource "azurerm_role_assignment" "role" {
  for_each = { for k, v in var.role_assignments : k => v }

  scope                = each.value.scope
  role_definition_name = each.value.role_name
  principal_id         = azurerm_user_assigned_identity.umi.principal_id
}