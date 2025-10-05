variable "resource_group_name" {
  type    = string
  default = "rg-demo-dev"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "create_vm" {
  type    = bool
  default = false
}

variable "vm_os" {
  type    = string
  default = "none"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "vm_admin_username" {
  type    = string
  default = "azureuser"
}

variable "vm_admin_password" {
  type    = string
  default = ""
  description = "Admin password for Windows VMs. Set via secrets in production."
}

variable "vm_ssh_public_key" {
  type    = string
  default = ""
  description = "SSH public key for Linux VMs. Set via secrets in production."
}
