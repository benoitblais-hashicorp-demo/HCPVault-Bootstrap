# Enable userpass auth method for admin users.
resource "vault_auth_backend" "userpass" {
  type        = "userpass"
  path        = var.vault_userpass_auth_backend_path
  description = var.vault_userpass_auth_backend_description
}

# The following resources block create platform-admin users with appropriate policies.

# Platform-admin policy with full access to Vault.
resource "vault_policy" "platform_admin" {
  name   = var.platform_admin_policy_name
  policy = file("${path.module}/policies/platform-admin.hcl")
}

# Generate random password for platform-admin user.
resource "random_password" "platform_admin_password" {
  length           = 24
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}

# Create platform-admin user in userpass auth method.
resource "vault_generic_endpoint" "platform_admin_user" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/${var.platform_admin_username}"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true

  data_json = jsonencode({
    password = random_password.platform_admin_password.result
    policies = ["default", vault_policy.platform_admin.name]
  })
}

# Create identity entity for platform-admin user.
resource "vault_identity_entity" "platform_admin_entity" {
  name = var.platform_admin_username

  metadata = {
    description = "Identity entity for ${var.platform_admin_username} user."
  }

  depends_on = [vault_generic_endpoint.platform_admin_user]
}

# Create entity alias to link platform-admin user to entity.
resource "vault_identity_entity_alias" "platform_admin_alias" {
  name           = vault_identity_entity.platform_admin_entity.name
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.platform_admin_entity.id
}

# The following resources block create group management for platform-admin users.
# This allows easier management of multiple platform-admin users.

# Create platform-admin group for identity management.
resource "vault_identity_group" "platform_admin_group" {
  name     = var.platform_admin_group_name
  type     = "internal"
  policies = [vault_policy.platform_admin.name]
}

# Add platform-admin entity to platform-admin group.
resource "vault_identity_group_member_entity_ids" "platform_admin_group_members" {
  group_id          = vault_identity_group.platform_admin_group.id
  member_entity_ids = [vault_identity_entity.platform_admin_entity.id]
  exclusive         = false
}

# The following resources block create vault-admin users with appropriate policies.

# Vault-admin policy for administrative access.
resource "vault_policy" "vault_admin" {
  name   = var.vault_admin_policy_name
  policy = file("${path.module}/policies/vault-admin.hcl")
}

# Generate random password for vault-admin user.
resource "random_password" "vault_admin_password" {
  length           = 24
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}

# Create vault-admin user in userpass auth method.
resource "vault_generic_endpoint" "vault_admin_user" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/${var.vault_admin_username}"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true

  data_json = jsonencode({
    password = random_password.vault_admin_password.result
    policies = ["default",vault_policy.vault_admin.name]
  })

  depends_on = [vault_policy.vault_admin]
}

# Create identity entity for vault-admin user.
resource "vault_identity_entity" "vault_admin_entity" {
  name = var.vault_admin_username

  metadata = {
    description = "Identity entity for ${var.vault_admin_username} user."
  }
}

# Create entity alias to link vault-admin user to entity.
resource "vault_identity_entity_alias" "vault_admin_alias" {
  name           = vault_identity_entity.vault_admin_entity.name
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.vault_admin_entity.id
}

# The following resources block create group management for vault-admin users.
# This allows easier management of multiple vault-admin users.

# Create vault-admin group for identity management.
resource "vault_identity_group" "vault_admin_group" {
  name     = var.vault_admin_group_name
  type     = "internal"
  policies = [vault_policy.vault_admin.name]
}

# Add vault-admin entity to vault-admin group.
resource "vault_identity_group_member_entity_ids" "vault_admin_group_members" {
  group_id          = vault_identity_group.vault_admin_group.id
  member_entity_ids = [vault_identity_entity.vault_admin_entity.id]
  exclusive         = false
}

# The following resources block enable JWT authentication for HCP Terraform.

# Enable JWT auth method at custom path.
resource "vault_jwt_auth_backend" "jwt" {
  path               = var.vault_jwt_auth_backend_path
  description        = var.vault_jwt_auth_backend_description
  oidc_discovery_url = var.jwt_oidc_discovery_url
  bound_issuer       = var.jwt_bound_issuer
}

# Policy for automation access.
resource "vault_policy" "automation" {
  name   = var.automation_policy_name
  policy = file("${path.module}/policies/automation.hcl")
}

# JWT role for HCP Terraform targeting HCP Vault project
resource "vault_jwt_auth_backend_role" "hcp_terraform_vault" {
  backend        = vault_jwt_auth_backend.jwt.path
  role_name      = var.jwt_role_name
  token_policies = [vault_policy.automation.name]

  bound_audiences = [var.jwt_tfc_audience]
  bound_claims = {
    "terraform_project_name" = var.jwt_terraform_project_name
  }

  user_claim             = var.jwt_user_claim
  role_type              = vault_jwt_auth_backend.jwt.type
  token_ttl              = var.jwt_token_ttl
  token_max_ttl          = var.jwt_token_max_ttl
  token_explicit_max_ttl = var.jwt_token_explicit_max_ttl
}

# The following resources block create TFE variables for HCP Vault authentication.

resource "tfe_variable" "vault_addr" {
  count           = var.vault_variable_set_id != null ? 1 : 0
  key             = "TFC_VAULT_ADDR"
  value           = var.vault_address
  variable_set_id = var.vault_variable_set_id
  category        = "env"
  description     = "Vault server address for HCP workspace authentication."
  sensitive       = false
}

resource "tfe_variable" "vault_auth_path" {
  count           = var.vault_variable_set_id != null ? 1 : 0
  key             = "TFC_VAULT_AUTH_PATH"
  value           = vault_jwt_auth_backend.jwt.path
  variable_set_id = var.vault_variable_set_id
  category        = "env"
  description     = "Vault authentication path for HCP workspace."
  sensitive       = false
}

resource "tfe_variable" "vault_namespace" {
  count           = var.vault_variable_set_id != null ? 1 : 0
  key             = "TFC_VAULT_NAMESPACE"
  value           = var.vault_namespace
  variable_set_id = var.vault_variable_set_id
  category        = "env"
  description     = "Vault namespace for HCP workspace."
  sensitive       = false
}

resource "tfe_variable" "vault_provider_auth" {
  count           = var.vault_variable_set_id != null ? 1 : 0
  key             = "TFC_VAULT_PROVIDER_AUTH"
  value           = "true"
  variable_set_id = var.vault_variable_set_id
  category        = "env"
  description     = "Vault provider authentication method for HCP workspace."
  sensitive       = false
}

resource "tfe_variable" "vault_run_role" {
  count           = var.vault_variable_set_id != null ? 1 : 0
  key             = "TFC_VAULT_RUN_ROLE"
  value           = vault_jwt_auth_backend_role.hcp_terraform_vault.role_name
  variable_set_id = var.vault_variable_set_id
  category        = "env"
  description     = "Vault run role for HCP workspace."
  sensitive       = false
}
