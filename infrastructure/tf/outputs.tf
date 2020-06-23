output "app_service_url" {
  value = azurerm_app_service.service.default_site_hostname
}
output "app_service_name" {
  value = azurerm_app_service.service.name
}

output "app_service_plan_name" {
  value = azurerm_app_service_plan.plan.name
}