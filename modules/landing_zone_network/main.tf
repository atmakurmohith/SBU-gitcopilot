variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "spoke" {
  name                 = "spoke-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.1.1.0/24"]
}
