variable "resource_group_name" {
  type    = string
  default = "rg-migration"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "create_vm" {
  type    = bool
  default = true
}

variable "vm_os" {
  type    = string
  default = "ubuntu"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "sample_vms" {
  type = list(object({
    name = string
    vm_os = string
    vm_size = string
    create = bool
  }))
  default = [
    {
      name = "sample-vm-1"
      vm_os = "ubuntu"
      vm_size = "Standard_B1s"
      create = true
    }
  ]
}
