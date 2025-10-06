Migration landing zone demo

This folder contains a minimal landing zone and a sample VM module for testing migration flows.

Files:
- main.tf: uses modules/landing_zone_network and modules/vm to create a sample VM
- variables.tf: provides defaults
- backend.hcl: local backend for demo

Quick start (locally):
1. cd envs/migration
2. terraform init
3. terraform plan
4. terraform apply (ensure AZURE credentials available via environment or workflow)

Notes:
- This is a small demo. For production you should replace the local backend with an Azure Storage backend and add proper subnet/NSG/route/peering configuration.
- Use the repository workflow to run this in CI: select environment 'migration' and operation 'plan' or 'apply'.
