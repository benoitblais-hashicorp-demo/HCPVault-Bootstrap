# Enable userpass auth method at custom path for admin access
resource "vault_auth_backend" "admin_userpass" {
  type        = "userpass"
  path        = "userpass-admin"
  description = "Userpass authentication method for administrative access"
}

# Superadmin policy with full access to Vault
resource "vault_policy" "superadmin" {
  name   = "superadmin"
  policy = file("${path.module}/policies/superadmin.hcl")
}

# Admin policy for administrative access
resource "vault_policy" "admin" {
  name   = "admin"
  policy = file("${path.module}/policies/admins.hcl")
}

# Generate random password for superadmin user
resource "random_password" "superadmin_password" {
  length           = 24
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}

# Generate random password for admin user
resource "random_password" "admin_password" {
  length           = 24
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}

# Create superadmin user in userpass-admin auth method
resource "vault_generic_endpoint" "superadmin_user" {
  path                 = "auth/${vault_auth_backend.admin_userpass.path}/users/superadmin"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true

  data_json = jsonencode({
    password = random_password.superadmin_password.result
    policies = ["default", vault_policy.superadmin.name]
  })

  depends_on = [vault_policy.superadmin]
}

# Create admin user in userpass-admin auth method
resource "vault_generic_endpoint" "admin_user" {
  path                 = "auth/${vault_auth_backend.admin_userpass.path}/users/admin"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true

  data_json = jsonencode({
    password = random_password.admin_password.result
    policies = ["default", vault_policy.admin.name]
  })

  depends_on = [vault_policy.admin]
}

# Create admin group for identity management
resource "vault_identity_group" "admin_group" {
  name     = "admin-group"
  type     = "internal"
  policies = [vault_policy.admin.name]

  metadata = {
    description = "Group for administrative users"
  }
}

# Create identity entity for admin user
resource "vault_identity_entity" "admin_entity" {
  name     = "admin"
  policies = [vault_policy.admin.name]

  metadata = {
    description = "Identity entity for admin user"
  }
}

# Create entity alias to link admin user to entity
resource "vault_identity_entity_alias" "admin_alias" {
  name           = "admin"
  mount_accessor = vault_auth_backend.admin_userpass.accessor
  canonical_id   = vault_identity_entity.admin_entity.id
}

# Add admin entity to admin group
resource "vault_identity_group_member_entity_ids" "admin_group_members" {
  group_id          = vault_identity_group.admin_group.id
  member_entity_ids = [vault_identity_entity.admin_entity.id]
  exclusive         = false
}

# Enable JWT auth method
resource "vault_jwt_auth_backend" "jwt" {
  path               = "jwt_hcp"
  description        = "JWT authentication method for HCP Terraform"
  oidc_discovery_url = var.jwt_oidc_discovery_url
  bound_issuer       = var.jwt_bound_issuer
}

# JWT role for HCP Terraform targeting HCP Vault project
resource "vault_jwt_auth_backend_role" "hcp_terraform_vault" {
  backend        = vault_jwt_auth_backend.jwt.path
  role_name      = "hcp-terraform-vault"
  token_policies = [vault_policy.superadmin.name]

  bound_audiences = [var.jwt_tfc_audience]
  bound_claims = {
    "terraform_project_name" = "HCP Vault"
  }

  user_claim             = "terraform_run_id"
  role_type              = "jwt"
  token_ttl              = 1200
  token_max_ttl          = 1200
  token_explicit_max_ttl = 0
}