variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vm_name" { type = string }
variable "vm_size" { type = string }
variable "vm_os" { type = string }
variable "create_vm" { type = bool }
variable "vm_admin_username" {
  type    = string
  default = "azureuser"
}

variable "vm_admin_password" {
  type    = string
  default = ""
}

variable "vm_ssh_public_key" {
  type    = string
  default = ""
}

resource "azurerm_network_interface" "nic" {
  count               = var.create_vm ? 1 : 0
  name                = "nic-${var.vm_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = data.azurerm_subnet.target[0].id
    private_ip_address_allocation = "Dynamic"
  }
}

data "azurerm_subnet" "target" {
  name                 = "spoke-subnet"
  virtual_network_name = "hub-vnet"
  resource_group_name  = var.resource_group_name
}

resource "azurerm_linux_virtual_machine" "linux" {
  count               = var.create_vm && var.vm_os != "windows" ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.nic[0].id]

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

resource "azurerm_windows_virtual_machine" "win" {
  count               = var.create_vm && var.vm_os == "windows" ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  network_interface_ids = [azurerm_network_interface.nic[0].id]

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
