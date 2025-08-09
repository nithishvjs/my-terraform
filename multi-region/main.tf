provider "azurerm" {
  features {}
}

module "vm1"{
  source = "D:/Terraform/module-vm"
  sub_id = "6f0d4b2c-9d4e-4231-9bbf-b27071f778ee"
  rm_name = var.rm_name
  rm_location = var.rm_location
  vm_name = var.vm_name
}

module "vm2"{
  source = "D:/Terraform/module-vm"
  sub_id = "6f0d4b2c-9d4e-4231-9bbf-b27071f778ee"
  rm_name = var.rm_name2
  rm_location = var.rm_location2
  vm_name = var.vm_name2
}