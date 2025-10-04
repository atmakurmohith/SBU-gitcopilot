output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Resource group location"
  value       = azurerm_resource_group.rg.location
}

output "vnet_id" {
  description = "Virtual network id"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "Subnet id"
  value       = azurerm_subnet.subnet.id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.storage.name
}
