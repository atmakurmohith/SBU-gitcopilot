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

// Azure Firewall needs a dedicated subnet named 'AzureFirewallSubnet'
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.1.2.0/26"]
}

resource "azurerm_public_ip" "firewall_pip" {
  name                = "fw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = "azure-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }
}

resource "azurerm_route_table" "rt" {
  name                = "rt-via-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "route_internet" {
  name                   = "route-to-internet"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "assoc" {
  subnet_id      = azurerm_subnet.spoke.id
  route_table_id = azurerm_route_table.rt.id
}

output "spoke_subnet_id" {
  value = azurerm_subnet.spoke.id
}

output "firewall_pip" {
  value = azurerm_public_ip.firewall_pip.ip_address
  description = "Public IP address assigned to Azure Firewall"
}
