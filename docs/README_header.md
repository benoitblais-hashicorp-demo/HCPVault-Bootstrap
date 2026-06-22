
# HCP Vault Bootstrap

This Terraform configuration bootstraps HashiCorp Vault with authentication methods, policies, users, and groups for administrative access and HCP Terraform integration.

## Permissions

### Vault Provider Permissions

The Vault provider requires a token with sufficient permissions to:

- Create and manage authentication methods (`sys/auth/*`)
- Create and manage policies (`sys/policies/acl/*`)
- Create and manage identity entities and groups (`identity/*`)
- Configure authentication backends and roles

## Authentication

### Vault Provider Authentication

Configure the Vault provider using environment variables:

- `VAULT_ADDR` - The address of the Vault server (e.g., `https://vault.example.com:8200`)
- `VAULT_TOKEN` - A Vault token with appropriate permissions
- `VAULT_NAMESPACE` - (Optional) The Vault namespace to use

## Features

- **Userpass Authentication**: Configures userpass auth method at `userpass-admin` path for administrative access
- **User Management**: Creates two administrative users, both fully integrated into Vault's identity system:
  - `platform-admin` - User with platform-admin policy (full access), identity entity, group, and alias
  - `vault-admin` - User with vault-admin policy (administrative capabilities), identity entity, group, and alias
- **Policy Management**: Manages policies from external HCL files:
  - Platform-admin policy (`policies/platform-admin.hcl`) - Full access to all Vault paths
  - Vault-admin policy (`policies/vault-admin.hcl`) - Administrative permissions
  - Automation policy (`policies/automation.hcl`) - HCP Terraform automation permissions
- **Identity System**: Configures Vault identity entities, groups, and aliases for both users.
- **JWT Authentication**: Enables JWT/OIDC authentication for HCP Terraform integration
- **HCP Terraform Integration**: Configures JWT role for HCP Terraform workloads across the entire HCP Terraform organization
- **TFE Variable Set Integration**: Optionally writes Vault environment variables into an HCP Terraform variable set
- **Random Password Generation**: Generates secure, complex passwords for all users (24 characters with special characters)
