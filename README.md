# Terraform Azure starter

This is a small Terraform starter that provisions an Azure Resource Group, Virtual Network, Subnet, and Storage Account.

Quick start

1. Install Terraform (>= 1.0).
2. Authenticate to Azure (for example: `az login`).
3. Copy `terraform.tfvars.example` to `terraform.tfvars` and edit as needed.
4. Run:

```powershell
terraform init
terraform plan
terraform apply
```

Notes

- The provider used is `hashicorp/azurerm`.
- Modify or extend resources in `main.tf`.
