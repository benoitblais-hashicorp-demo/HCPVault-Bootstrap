<!-- BEGIN_TF_DOCS -->
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

Example:
```bash
export VAULT_ADDR="https://vault.example.com:8200"
export VAULT_TOKEN="your-vault-token"
export VAULT_NAMESPACE="admin"
```

## Features

- **Userpass Authentication**: Configures userpass auth method at `userpass-admin` path for administrative access
- **User Management**: Creates two administrative users:
  - `superadmin` - User with root policy (full access)
  - `admin` - User with admin policy (administrative capabilities)
- **Policy Management**: Manages policies from external HCL files:
  - Root policy (`policies/root.hcl`) - Full access to all Vault paths
  - Admin policy (`policies/admins.hcl`) - Administrative permissions
- **Identity System**: Configures Vault identity entities, groups, and aliases for centralized access management
- **JWT Authentication**: Enables JWT/OIDC authentication for HCP Terraform integration
- **HCP Terraform Integration**: Configures JWT role for HCP Terraform workloads in the "HCP Vault" project
- **Random Password Generation**: Generates secure, complex passwords for all users (24 characters with special characters)

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (3.6.3)

- <a name="requirement_vault"></a> [vault](#requirement\_vault) (4.5.0)

## Modules

No modules.

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_jwt_bound_issuer"></a> [jwt\_bound\_issuer](#input\_jwt\_bound\_issuer)

Description: The value against which to match the iss claim in a JWT

Type: `string`

Default: `"https://app.terraform.io"`

### <a name="input_jwt_oidc_discovery_url"></a> [jwt\_oidc\_discovery\_url](#input\_jwt\_oidc\_discovery\_url)

Description: The OIDC Discovery URL, without any .well-known component (base path)

Type: `string`

Default: `"https://app.terraform.io"`

### <a name="input_jwt_tfc_audience"></a> [jwt\_tfc\_audience](#input\_jwt\_tfc\_audience)

Description: The audience value for HCP Terraform JWT tokens

Type: `string`

Default: `"vault.workload.identity"`

## Resources

The following resources are used by this module:

- [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) (resource)
- [random_password.superadmin_password](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) (resource)
- [vault_auth_backend.admin_userpass](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/auth_backend) (resource)
- [vault_generic_endpoint.admin_user](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/generic_endpoint) (resource)
- [vault_generic_endpoint.superadmin_user](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/generic_endpoint) (resource)
- [vault_identity_entity.admin_entity](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_entity) (resource)
- [vault_identity_entity_alias.admin_alias](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_entity_alias) (resource)
- [vault_identity_group.admin_group](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_group) (resource)
- [vault_identity_group_member_entity_ids.admin_group_members](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_group_member_entity_ids) (resource)
- [vault_jwt_auth_backend.jwt](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/jwt_auth_backend) (resource)
- [vault_jwt_auth_backend_role.hcp_terraform_vault](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/jwt_auth_backend_role) (resource)
- [vault_policy.admin](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/policy) (resource)
- [vault_policy.root](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/policy) (resource)

## Outputs

The following outputs are exported:

### <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password)

Description: Password for the admin user in userpass-admin auth method

### <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username)

Description: Username for the admin user in userpass-admin auth method

### <a name="output_admin_userpass_path"></a> [admin\_userpass\_path](#output\_admin\_userpass\_path)

Description: Path where the admin userpass authentication method is mounted

### <a name="output_jwt_auth_path"></a> [jwt\_auth\_path](#output\_jwt\_auth\_path)

Description: Path where the JWT authentication method is mounted

### <a name="output_jwt_role_hcp_terraform_vault"></a> [jwt\_role\_hcp\_terraform\_vault](#output\_jwt\_role\_hcp\_terraform\_vault)

Description: Name of the JWT role for HCP Terraform HCP Vault project

### <a name="output_superadmin_password"></a> [superadmin\_password](#output\_superadmin\_password)

Description: Password for the superadmin user in userpass-admin auth method

### <a name="output_superadmin_username"></a> [superadmin\_username](#output\_superadmin\_username)

Description: Username for the superadmin user in userpass-admin auth method

<!-- markdownlint-enable -->
<!-- markdownlint-disable-next-line MD041 -->
## External Documentation

This configuration was built using the following official documentation:

- [Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)
- [Vault Userpass Auth Method](https://developer.hashicorp.com/vault/docs/auth/userpass)
- [Vault JWT/OIDC Auth Method](https://developer.hashicorp.com/vault/docs/auth/jwt)
- [Vault Policies](https://developer.hashicorp.com/vault/docs/concepts/policies)
- [Vault Identity System](https://developer.hashicorp.com/vault/docs/secrets/identity)
- [HCP Terraform Dynamic Provider Credentials](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials)
<!-- END_TF_DOCS -->