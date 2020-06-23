# The resource group holding the infra
data "azurerm_resource_group" "main" {
  name = "rg-${local.project_suffix}"
}