provider "azurerm" {
  features {}
  subscription_id = "0bbf33a8-9546-484e-a5c7-5258ea4d2fb2"
}

resource "azurerm_resource_group" "example" {
  name     = "nithi"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "my-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix = "myaks"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_b2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
