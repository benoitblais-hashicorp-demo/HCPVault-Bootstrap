# Enable userpass auth method at custom path for admin access
resource "vault_auth_backend" "admin_userpass" {
  type        = "userpass"
  path        = "userpass-admin"
  description = "Userpass authentication method for administrative access"
}

# Superadmin policy with full access to Vault
# resource "vault_policy" "superadmin" {
#   name   = "superadmin"
#   policy = file("${path.module}/policies/superadmin.hcl")
# }

# Admin policy for administrative access
resource "vault_policy" "opsadmin" {
  name   = "opsadmin"
  policy = file("${path.module}/policies/admins.hcl")
}

# Generate random password for superadmin user
# resource "random_password" "superadmin_password" {
#   length           = 24
#   special          = true
#   min_lower        = 1
#   min_numeric      = 1
#   min_special      = 1
#   min_upper        = 1
#   override_special = "!@#$%^&*()_+-=[]{}|;:,.<>?"
# }

# Generate random password for admin user
resource "random_password" "opsadmin_password" {
  length           = 24
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}

# Create superadmin user in userpass-admin auth method
# resource "vault_generic_endpoint" "superadmin_user" {
#   path                 = "auth/${vault_auth_backend.admin_userpass.path}/users/superadmin"
#   ignore_absent_fields = true
#   disable_read         = true
#   disable_delete       = true

#   data_json = jsonencode({
#     password = random_password.superadmin_password.result
#     policies = ["default", vault_policy.superadmin.name]
#   })

#   depends_on = [vault_policy.superadmin]
# }

# Create opsadmin user in userpass-admin auth method
resource "vault_generic_endpoint" "opsadmin_user" {
  path                 = "auth/${vault_auth_backend.admin_userpass.path}/users/opsadmin"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true

  data_json = jsonencode({
    password = random_password.opsadmin_password.result
    policies = ["default", vault_policy.opsadmin.name]
  })

  depends_on = [vault_policy.opsadmin]
}

# Create identity entity for superadmin user
# resource "vault_identity_entity" "superadmin_entity" {
#   name     = "superadmin"
#   policies = [vault_policy.superadmin.name]

#   metadata = {
#     description = "Identity entity for superadmin user"
#   }
# }

# Create identity entity for opsadmin user
resource "vault_identity_entity" "opsadmin_entity" {
  name     = "opsadmin"
  policies = [vault_policy.opsadmin.name]

  metadata = {
    description = "Identity entity for opsadmin user"
  }
}

# Create entity alias to link superadmin user to entity
# resource "vault_identity_entity_alias" "superadmin_alias" {
#   name           = "superadmin"
#   mount_accessor = vault_auth_backend.admin_userpass.accessor
#   canonical_id   = vault_identity_entity.superadmin_entity.id
# }

# Create entity alias to link opsadmin user to entity
resource "vault_identity_entity_alias" "opsadmin_alias" {
  name           = "opsadmin"
  mount_accessor = vault_auth_backend.admin_userpass.accessor
  canonical_id   = vault_identity_entity.opsadmin_entity.id
}

# Create superadmin group for identity management
# resource "vault_identity_group" "superadmin_group" {
#   name     = "superadmin-group"
#   type     = "internal"
#   policies = [vault_policy.superadmin.name]

#   metadata = {
#     description = "Group for superadmin users"
#   }
# }

# Create opsadmin group for identity management
resource "vault_identity_group" "opsadmin_group" {
  name     = "opsadmin-group"
  type     = "internal"
  policies = [vault_policy.opsadmin.name]

  metadata = {
    description = "Group for administrative users"
  }
}

# Add superadmin entity to superadmin group
# resource "vault_identity_group_member_entity_ids" "superadmin_group_members" {
#   group_id          = vault_identity_group.superadmin_group.id
#   member_entity_ids = [vault_identity_entity.superadmin_entity.id]
#   exclusive         = false
# }

# Add opsadmin entity to opsadmin group
resource "vault_identity_group_member_entity_ids" "opsadmin_group_members" {
  group_id          = vault_identity_group.opsadmin_group.id
  member_entity_ids = [vault_identity_entity.opsadmin_entity.id]
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
