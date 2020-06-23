terraform {
  required_version = ">= 0.12"
  backend "azurerm" {}
}

provider "azurerm" {
  version = "~> 1.31"
  skip_provider_registration = true
}
