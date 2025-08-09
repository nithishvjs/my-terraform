terraform{
    backend "azurerm"{
        resource_group_name = "blobrm-resources"
        storage_account_name = "tfstateaccnithi"
        container_name = "tfstate"
        key = "terraform.tfstate"
    }
}