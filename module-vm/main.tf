provider "azurerm" {
  features {}
  subscription_id = var.sub_id
}

# Resource Group
resource "azurerm_resource_group" "Test" {
  name     = var.rm_name
  location = var.rm_location
}

# Virtual Network
resource "azurerm_virtual_network" "Test" {
  name                = "Test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Test.location
  resource_group_name = azurerm_resource_group.Test.name
}

# Subnet
resource "azurerm_subnet" "Test" {
  name                 = "Test-subnet"
  resource_group_name  = azurerm_resource_group.Test.name
  virtual_network_name = azurerm_virtual_network.Test.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP Declaration
resource "azurerm_public_ip" "Test" {
  name                = "Test-public-ip"
  location            = azurerm_resource_group.Test.location
  resource_group_name = azurerm_resource_group.Test.name
  allocation_method   = "Static"
}

# Network Interface with Public IP
resource "azurerm_network_interface" "Test" {
  name                = "Test-nic"
  location            = azurerm_resource_group.Test.location
  resource_group_name = azurerm_resource_group.Test.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Test.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Test.id # Associate Public IP
  }
}


# Ubuntu Virtual Machine
resource "azurerm_linux_virtual_machine" "Test" {
  name                = "Test-vm"
  resource_group_name = azurerm_resource_group.Test.name
  location            = azurerm_resource_group.Test.location
  size                = "Standard_B1s"

  admin_username = "azureuser"
  admin_password = "Pradeesh@2!" # Use SSH keys for better security in production
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.Test.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference{
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS"
    version   = "latest"
  }
}