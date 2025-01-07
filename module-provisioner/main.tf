# Define the Azure provider configuration
provider "azurerm" {
  features {}
  subscription_id = ""
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "terraform-vnet"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "terraform-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

# Create a public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "terraform-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

# Create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "terraform-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "terraform-ip-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Create a Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "terraform-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_key_path)
  }
  connection {
      type     = "ssh"
      host     = self.public_ip_address
      user     = "azureuser"
      private_key = file("~/.ssh/id_rsa")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

provisioner "file" {
  source = "bash.sh"
  destination = "/home/azureuser/bash.sh"
}

provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y apache2",
    "sudo systemctl start apache2",
    "sudo systemctl enable apache2",
    "sudo mkdir -p /var/www/html",
    "echo '<h1> hello world!! </h1>' | sudo tee /var/www/html/index.html" ,
  ]
}


  tags = {
    environment = "TerraformDemo"
  }
}
