# Variables for configuration
variable "resource_group_name" {
  default = "terraform-rg"
}

variable "location" {
  default = "East US"
}

variable "vnet_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}