provider "azurerm" {
  features {}
  subscription_id = ""
}

resource "azurerm_resource_group" "blobrm" {
  name     = "blobrm-resources"
  location = "East US"
}

resource "azurerm_storage_account" "blobrm" {
  name                     = "tfstateaccnithi"
  resource_group_name      = azurerm_resource_group.blobrm.name
  location                 = azurerm_resource_group.blobrm.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blobrm" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.blobrm.name
  container_access_type = "private"
}
