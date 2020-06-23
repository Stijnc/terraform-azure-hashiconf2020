resource "azurerm_app_service_plan" "plan" {
  name                = "asp-${local.project_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = local.common_tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_app_service" "service" {
  name                = "as-${local.project_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  https_only          = var.https_only

  site_config {
    http2_enabled   = var.http2_enabled
    min_tls_version = var.min_tls_version
  }

  app_settings = local.app_settings
}
