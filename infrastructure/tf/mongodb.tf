resource "random_password" "mongodbadminpass" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_storage_account" "aci_sta" {
  name                     = "staaci${local.project_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  account_tier             = "standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "aci_share" {
  name                 = local.project_suffix
  storage_account_name = azurerm_storage_account.aci_sta.name
  quota                = 50
}

resource "azurerm_container_group" "cgroup" {
  name                = "acg-${local.project_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_address_type     = "public"
  dns_name_label      = local.project_suffix
  os_type             = "Linux"

  container {
    name   = "mongodb"
    image  = var.acg_mongodb_image
    cpu    = var.acg_mongodb_cpu
    memory = var.acg_mongodb_memory

    ports {
      port     = 27017
      protocol = "TCP"
    }
    /* Can't get persistant storage to work with mongoDB - write issues
    volume {
      name                 = "mongodbdata"
      mount_path           = "/bitnami/mongodb"
      read_only            = false
      share_name           = azurerm_storage_share.aci_share.name
      storage_account_name = azurerm_storage_account.aci_sta.name
      storage_account_key  = azurerm_storage_account.aci_sta.primary_access_key
    }
    */
    environment_variables = {
      MONGODB_PASSWORD = random_password.mongodbadminpass.result
      MONGODB_USERNAME = var.acg_mongodb_admin_user
    }
  }

  tags = local.common_tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

locals {
  mongodb_connection_string = "mongodb://${var.acg_mongodb_admin_user}:${random_password.mongodbadminpass.result}@${azurerm_container_group.cgroup.fqdn}:27017"
}