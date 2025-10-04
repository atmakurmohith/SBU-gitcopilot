variable "location" {
  description = "Azure region to deploy resources into"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group to create"
  type        = string
  default     = "rg-demo-terraform"
}

variable "name_prefix" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "demo"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "storage_tier" {
  description = "Storage account performance tier (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "storage_replication" {
  description = "Storage account replication (LRS, GRS, etc.)"
  type        = string
  default     = "LRS"
}

variable "create_vm" {
  description = "Whether to create a VM"
  type        = bool
  default     = false
}

variable "vm_type" {
  description = "Type of VM to create: none, linux, windows, redhat"
  type        = string
  default     = "none"
}

variable "vm_admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Admin password for Windows VM (sensitive)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "vm_ssh_public_key" {
  description = "SSH public key for Linux VMs"
  type        = string
  default     = ""
}

variable "vm_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B1s"
}

