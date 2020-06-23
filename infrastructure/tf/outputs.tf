output "app_service_url" {
  value = azurerm_app_service.service.default_site_hostname
}
output "app_service_name" {
  value = azurerm_app_service.service.name
}

output "app_service_plan_name" {
  value = azurerm_app_service_plan.plan.name
}

output "sql_server_fqdn" {
  value = azurerm_sql_server.mssql.fully_qualified_domain_name
}

output "sql_database_name" {
  value = azurerm_sql_database.mssqldatabase.name
}

output "mongodb_server_fqdn" {
  value = azurerm_container_group.cgroup.fqdn
}