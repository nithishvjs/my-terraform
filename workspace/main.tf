provider "azurerm" {
  features {}
}

variable "rm_location" {
  description = "value"
  type = map(string)

  default = {
    "dev" = "West Europe"
    "stage" = "East US"
    "prod" = "West US"
  }
}

module "workspace-vm" {
  source = "D:/Devops/module-vm"
  sub_id = ""
  rm_name = "first-group"
  rm_location = lookup(var.rm_location, terraform.workspace, "West US")
}