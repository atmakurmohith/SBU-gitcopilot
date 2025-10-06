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
  subnet_id = module.landing_zone_network.spoke_subnet_id
}

/* multiple sample VMs driven by variable */
module "sample_vms" {
  source = "../modules/vm"
  for_each = { for vm in var.sample_vms : vm.name => vm }

  resource_group_name = var.resource_group_name
  location = var.location
  vm_name = each.value.name
  vm_size = each.value.vm_size
  vm_os = each.value.vm_os
  create_vm = each.value.create
  subnet_id = module.landing_zone_network.spoke_subnet_id
}

output "sample_vm_public_ips" {
  value = { for k, m in module.sample_vms : k => try(m.public_ip, "") }
}
