resource "random_password" "sqlserveradminpass" {
  length           = 32
  special          = true
  override_special = "_%@"
}


resource "azurerm_sql_server" "mssql" {
  name                         = "amss-${local.project_suffix}"
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_server_admin_user
  administrator_login_password = random_password.sqlserveradminpass.result

  tags = local.common_tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_sql_database" "mssqldatabase" {
  name                = "db-${local.project_suffix}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  server_name         = azurerm_sql_server.mssql.name
}

resource "azurerm_sql_firewall_rule" "azure_access" {
  name                = "Azure Access"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_sql_server.mssql.name

}

locals {
  mssql_connection_string = "Server=tcp:${azurerm_sql_server.mssql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.mssqldatabase.name};Persist Security Info=False;User ID=${azurerm_sql_server.mssql.administrator_login};Password=${azurerm_sql_server.mssql.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}