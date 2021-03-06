# locals
###########################
locals {
  project_suffix = var.project

  common_tags = {
    owner   = var.owner
    project = var.project
  }

  node_default_version = {
    WEBSITE_NODE_DEFAULT_VERSION = "10.15.2"
  }

  app_settings = merge(
    var.app_settings,
    local.node_default_version
  )
}

# data sources
###########################
variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource goup"
}

# variables
###########################

variable "owner" {
  type        = string
  default     = ""
  description = "the project owner of the resources"
}
variable "project" {
  type        = string
  default     = ""
  description = "the project name resources belong to"
}

variable "app_service_plan_sku" {
  type = map(string)
  default = {
    tier = "Standard"
    size = "S1"
  }
}

variable "https_only" {
  type        = bool
  default     = true
  description = "Redirect all traffic made to the web app using HTTP to HTTPS."
}

variable "http2_enabled" {
  type        = bool
  default     = true
  description = "Whether clients are allowed to connect over HTTP 2.0."
}

variable "min_tls_version" {
  type        = string
  default     = "1.2"
  description = "The minimum supported TLS version."
}

variable app_settings {
  type = map(string)
  default = {
    "ApiUrl"                 = "/api/v1"
    "ApiUrlShoppingCart"     = "/api/v1"
    "MongoConnectionString"  = ""
    "SqlConnectionString"    = ""
    "productImagesUrl"       = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
    "Personalizer__ApiKey"   = ""
    "Personalizer__Endpoint" = ""
  }
  description = "Map of the application settings"
}

variable sql_server_admin_user {
  type        = string
  default     = "sqladmin"
  description = "Azure SQL server administrator"
}

variable sql_server_version {
  type        = string
  default     = "12.0"
  description = "The SQL server version"
}

variable acg_mongodb_image {
  type = string 
  default = "bitnami/mongodb:4.2.8"
}

variable acg_mongodb_cpu {
  default = 2
}

variable acg_mongodb_memory {
  default = 2
}

variable acg_mongodb_admin_user {
  type = string
  default = "mongodbadmin"
}
