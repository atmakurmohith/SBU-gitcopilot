terraform {
  backend "local" {}
}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  type    = string
  default = "rg-demo-dev"
}

variable "location" {
  type    = string
  default = "eastus"
}

// Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

// Virtual network and subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

// Public IP for VM (created only if create_vm is true)
resource "azurerm_public_ip" "vm_pip" {
  count               = var.create_vm ? 1 : 0
  name                = "pip-${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vm_nic" {
  count               = var.create_vm ? 1 : 0
  name                = "nic-${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_vm ? azurerm_public_ip.vm_pip[0].id : null
  }
}

// Linux VM (Ubuntu/RedHat)
resource "azurerm_linux_virtual_machine" "linux_vm" {
  count               = var.create_vm && (var.vm_os != "windows") ? 1 : 0
  name                = "vm-${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username

  network_interface_ids = [azurerm_network_interface.vm_nic[0].id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.vm_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_os == "redhat" ? "RedHat" : "Canonical"
    offer     = var.vm_os == "redhat" ? "RHEL" : "UbuntuServer"
    sku       = var.vm_os == "redhat" ? "8" : "20_04-lts"
    version   = "latest"
  }
}

// Windows VM
resource "azurerm_windows_virtual_machine" "win_vm" {
  count               = var.create_vm && var.vm_os == "windows" ? 1 : 0
  name                = "vm-${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password

  network_interface_ids = [azurerm_network_interface.vm_nic[0].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
