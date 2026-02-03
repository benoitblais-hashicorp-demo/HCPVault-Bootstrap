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

## Features

- **Userpass Authentication**: Configures userpass auth method at `userpass-admin` path for administrative access
- **User Management**: Creates two administrative users, both fully integrated into Vault's identity system:
  - `superadmin` - User with superadmin policy (full access), identity entity, group, and alias
  - `opsadmin` - User with admin policy (administrative capabilities), identity entity, group, and alias
- **Policy Management**: Manages policies from external HCL files:
  - Superadmin policy (`policies/superadmin.hcl`) - Full access to all Vault paths
  - Admin policy (`policies/admins.hcl`) - Administrative permissions
- **Identity System**: Configures Vault identity entities, groups, and aliases for both users. The `opsadmin` group is also a member of itself for demonstration of group nesting.
- **JWT Authentication**: Enables JWT/OIDC authentication for HCP Terraform integration
- **HCP Terraform Integration**: Configures JWT role for HCP Terraform workloads in the "HCP Vault" project
- **Random Password Generation**: Generates secure, complex passwords for all users (24 characters with special characters)

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (3.6.3)

- <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) (0.42.0)

- <a name="requirement_vault"></a> [vault](#requirement\_vault) (4.5.0)

## Modules

No modules.

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_automation_policy_name"></a> [automation\_policy\_name](#input\_automation\_policy\_name)

Description: (Optional) Name of the automation policy for HCP Terraform.

Type: `string`

Default: `"automation"`

### <a name="input_jwt_bound_issuer"></a> [jwt\_bound\_issuer](#input\_jwt\_bound\_issuer)

Description: (Optional) The value against which to match the iss claim in a JWT.

Type: `string`

Default: `"https://app.terraform.io"`

### <a name="input_jwt_oidc_discovery_url"></a> [jwt\_oidc\_discovery\_url](#input\_jwt\_oidc\_discovery\_url)

Description: (Optional) The OIDC Discovery URL, without any .well-known component (base path).

Type: `string`

Default: `"https://app.terraform.io"`

### <a name="input_jwt_role_name"></a> [jwt\_role\_name](#input\_jwt\_role\_name)

Description: (Optional) Name of the JWT role for HCP Terraform.

Type: `string`

Default: `"hcp-terraform-vault"`

### <a name="input_jwt_terraform_project_name"></a> [jwt\_terraform\_project\_name](#input\_jwt\_terraform\_project\_name)

Description: (Optional) Terraform project name for bound claims in JWT authentication.

Type: `string`

Default: `"HCP Vault"`

### <a name="input_jwt_tfc_audience"></a> [jwt\_tfc\_audience](#input\_jwt\_tfc\_audience)

Description: (Optional) The audience value for HCP Terraform JWT tokens.

Type: `string`

Default: `"vault.workload.identity"`

### <a name="input_jwt_token_explicit_max_ttl"></a> [jwt\_token\_explicit\_max\_ttl](#input\_jwt\_token\_explicit\_max\_ttl)

Description: (Optional) Token explicit max TTL in seconds for JWT authentication.

Type: `number`

Default: `0`

### <a name="input_jwt_token_max_ttl"></a> [jwt\_token\_max\_ttl](#input\_jwt\_token\_max\_ttl)

Description: (Optional) Token max TTL in seconds for JWT authentication.

Type: `number`

Default: `1200`

### <a name="input_jwt_token_ttl"></a> [jwt\_token\_ttl](#input\_jwt\_token\_ttl)

Description: (Optional) Token TTL in seconds for JWT authentication.

Type: `number`

Default: `1200`

### <a name="input_jwt_user_claim"></a> [jwt\_user\_claim](#input\_jwt\_user\_claim)

Description: (Optional) User claim field for JWT authentication.

Type: `string`

Default: `"terraform_run_id"`

### <a name="input_platform_admin_group_name"></a> [platform\_admin\_group\_name](#input\_platform\_admin\_group\_name)

Description: (Optional) The name of the platform-admin group.

Type: `string`

Default: `"platform-admin-group"`

### <a name="input_platform_admin_policy_name"></a> [platform\_admin\_policy\_name](#input\_platform\_admin\_policy\_name)

Description: (Optional) The name of the platform-admin policy.

Type: `string`

Default: `"platform-admin"`

### <a name="input_platform_admin_username"></a> [platform\_admin\_username](#input\_platform\_admin\_username)

Description: (Optional) The username for the platform-admin user.

Type: `string`

Default: `"platform-admin"`

### <a name="input_vault_admin_group_name"></a> [vault\_admin\_group\_name](#input\_vault\_admin\_group\_name)

Description: (Optional) The name of the vault-admin group.

Type: `string`

Default: `"vault-admin-group"`

### <a name="input_vault_admin_policy_name"></a> [vault\_admin\_policy\_name](#input\_vault\_admin\_policy\_name)

Description: (Optional) The name of the vault-admin policy.

Type: `string`

Default: `"vault-admin"`

### <a name="input_vault_admin_username"></a> [vault\_admin\_username](#input\_vault\_admin\_username)

Description: (Optional) The username for the vault-admin user.

Type: `string`

Default: `"vault-admin"`

### <a name="input_vault_jwt_auth_backend_description"></a> [vault\_jwt\_auth\_backend\_description](#input\_vault\_jwt\_auth\_backend\_description)

Description: (Optional) The description of the JWT auth backend for HCP Terraform.

Type: `string`

Default: `"JWT authentication method for HCP Terraform."`

### <a name="input_vault_jwt_auth_backend_path"></a> [vault\_jwt\_auth\_backend\_path](#input\_vault\_jwt\_auth\_backend\_path)

Description: (Optional) Path to mount the JWT/OIDC auth backend for HCP Terraform.

Type: `string`

Default: `"jwt_hcp"`

### <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace)

Description: (Optional) Vault namespace. Required for HCP workspace authentication.

Type: `string`

Default: `"admin"`

### <a name="input_vault_userpass_auth_backend_description"></a> [vault\_userpass\_auth\_backend\_description](#input\_vault\_userpass\_auth\_backend\_description)

Description: (Optional) A description of the userpass auth method.

Type: `string`

Default: `"Userpass authentication method for administrative access."`

### <a name="input_vault_userpass_auth_backend_path"></a> [vault\_userpass\_auth\_backend\_path](#input\_vault\_userpass\_auth\_backend\_path)

Description: (Optional) The path to mount the userpass auth method.

Type: `string`

Default: `"userpass-admin"`

### <a name="input_vault_variable_set_id"></a> [vault\_variable\_set\_id](#input\_vault\_variable\_set\_id)

Description: (Optional) The ID of the variable set for Vault authentication variables.

Type: `string`

Default: `null`

## Resources

The following resources are used by this module:

- [random_password.platform_admin_password](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) (resource)
- [random_password.vault_admin_password](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) (resource)
- [tfe_variable.vault_addr](https://registry.terraform.io/providers/hashicorp/tfe/0.42.0/docs/resources/variable) (resource)
- [tfe_variable.vault_auth_path](https://registry.terraform.io/providers/hashicorp/tfe/0.42.0/docs/resources/variable) (resource)
- [tfe_variable.vault_namespace](https://registry.terraform.io/providers/hashicorp/tfe/0.42.0/docs/resources/variable) (resource)
- [tfe_variable.vault_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/0.42.0/docs/resources/variable) (resource)
- [tfe_variable.vault_run_role](https://registry.terraform.io/providers/hashicorp/tfe/0.42.0/docs/resources/variable) (resource)
- [vault_auth_backend.userpass](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/auth_backend) (resource)
- [vault_generic_endpoint.platform_admin_user](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/generic_endpoint) (resource)
- [vault_generic_endpoint.vault_admin_user](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/generic_endpoint) (resource)
- [vault_identity_entity.platform_admin_entity](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_entity) (resource)
- [vault_identity_entity.vault_admin_entity](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_entity) (resource)
- [vault_identity_entity_alias.platform_admin_alias](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_entity_alias) (resource)
- [vault_identity_entity_alias.vault_admin_alias](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_entity_alias) (resource)
- [vault_identity_group.platform_admin_group](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_group) (resource)
- [vault_identity_group.vault_admin_group](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_group) (resource)
- [vault_identity_group_member_entity_ids.platform_admin_group_members](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_group_member_entity_ids) (resource)
- [vault_identity_group_member_entity_ids.vault_admin_group_members](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/identity_group_member_entity_ids) (resource)
- [vault_jwt_auth_backend.jwt](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/jwt_auth_backend) (resource)
- [vault_jwt_auth_backend_role.hcp_terraform_vault](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/jwt_auth_backend_role) (resource)
- [vault_policy.automation](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/policy) (resource)
- [vault_policy.platform_admin](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/policy) (resource)
- [vault_policy.vault_admin](https://registry.terraform.io/providers/hashicorp/vault/4.5.0/docs/resources/policy) (resource)

## Outputs

The following outputs are exported:

### <a name="output_jwt_auth_path"></a> [jwt\_auth\_path](#output\_jwt\_auth\_path)

Description: Path where the JWT authentication method is mounted

### <a name="output_jwt_role_hcp_terraform_vault"></a> [jwt\_role\_hcp\_terraform\_vault](#output\_jwt\_role\_hcp\_terraform\_vault)

Description: Name of the JWT role for HCP Terraform HCP Vault project

### <a name="output_platform_admin_password"></a> [platform\_admin\_password](#output\_platform\_admin\_password)

Description: Password for the platform-admin user in userpass-admin auth method

### <a name="output_platform_admin_username"></a> [platform\_admin\_username](#output\_platform\_admin\_username)

Description: Username for the platform-admin user in userpass-admin auth method

### <a name="output_userpass_auth_path"></a> [userpass\_auth\_path](#output\_userpass\_auth\_path)

Description: Path where the userpass authentication method is mounted

### <a name="output_vault_admin_password"></a> [vault\_admin\_password](#output\_vault\_admin\_password)

Description: Password for the vault-admin user in userpass-admin auth method

### <a name="output_vault_admin_username"></a> [vault\_admin\_username](#output\_vault\_admin\_username)

Description: Username for the vault-admin user in userpass-admin auth method

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