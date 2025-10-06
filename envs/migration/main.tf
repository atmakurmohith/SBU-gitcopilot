terraform {
  backend "local" {}
}

provider "azurerm" {
  features {}
}

module "landing_zone_network" {
  source = "../modules/landing_zone_network"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "sample_vm" {
  source = "../modules/vm"
  resource_group_name = var.resource_group_name
  location = var.location
  vm_name = "sample-migrated-vm"
  vm_size = var.vm_size
  vm_os = var.vm_os
  create_vm = var.create_vm
}
