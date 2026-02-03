variable "automation_policy_name" {
  type        = string
  description = "(Optional) Name of the automation policy for HCP Terraform."
  default     = "automation"
}

variable "jwt_bound_issuer" {
  type        = string
  description = "(Optional) The value against which to match the iss claim in a JWT."
  default     = "https://app.terraform.io"

  validation {
    condition     = can(regex("^https?://[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}(:[0-9]+)?(/.*)?$", var.jwt_bound_issuer))
    error_message = "JWT bound issuer must be a valid HTTP or HTTPS URL."
  }
}

variable "jwt_oidc_discovery_url" {
  type        = string
  description = "(Optional) The OIDC Discovery URL, without any .well-known component (base path)."
  default     = "https://app.terraform.io"

  validation {
    condition     = can(regex("^https?://[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}(:[0-9]+)?(/.*)?$", var.jwt_oidc_discovery_url))
    error_message = "OIDC discovery URL must be a valid HTTP or HTTPS URL."
  }
}

variable "jwt_role_name" {
  type        = string
  description = "(Optional) Name of the JWT role for HCP Terraform."
  default     = "hcp-terraform-vault"
}

variable "jwt_terraform_project_name" {
  type        = string
  description = "(Optional) Terraform project name for bound claims in JWT authentication."
  default     = "HCP Vault"
}

variable "jwt_tfc_audience" {
  type        = string
  description = "(Optional) The audience value for HCP Terraform JWT tokens."
  default     = "vault.workload.identity"
}

variable "jwt_token_explicit_max_ttl" {
  type        = number
  description = "(Optional) Token explicit max TTL in seconds for JWT authentication."
  default     = 0

  validation {
    condition     = var.jwt_token_explicit_max_ttl >= 0
    error_message = "Token explicit max TTL must be a non-negative value (0 for no limit)."
  }
}

variable "jwt_token_max_ttl" {
  type        = number
  description = "(Optional) Token max TTL in seconds for JWT authentication."
  default     = 1200

  validation {
    condition     = var.jwt_token_max_ttl > 0 && var.jwt_token_max_ttl <= 86400
    error_message = "Token max TTL must be between 1 and 86400 seconds (24 hours)."
  }
}

variable "jwt_token_ttl" {
  type        = number
  description = "(Optional) Token TTL in seconds for JWT authentication."
  default     = 1200

  validation {
    condition     = var.jwt_token_ttl > 0 && var.jwt_token_ttl <= 86400
    error_message = "Token TTL must be between 1 and 86400 seconds (24 hours)."
  }
}

variable "jwt_user_claim" {
  type        = string
  description = "(Optional) User claim field for JWT authentication."
  default     = "terraform_run_id"
}

variable "platform_admin_group_name" {
  type        = string
  description = "(Optional) The name of the platform-admin group."
  default     = "platform-admin-group"
}

variable "platform_admin_policy_name" {
  type        = string
  description = "(Optional) The name of the platform-admin policy."
  default     = "platform-admin"
}

variable "platform_admin_username" {
  type        = string
  description = "(Optional) The username for the platform-admin user."
  default     = "platform-admin"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.platform_admin_username)) && length(var.platform_admin_username) >= 3
    error_message = "Username must be at least 3 characters and contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "vault_admin_group_name" {
  type        = string
  description = "(Optional) The name of the vault-admin group."
  default     = "vault-admin-group"
}

variable "vault_admin_policy_name" {
  type        = string
  description = "(Optional) The name of the vault-admin policy."
  default     = "vault-admin"
}

variable "vault_admin_username" {
  type        = string
  description = "(Optional) The username for the vault-admin user."
  default     = "vault-admin"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.vault_admin_username)) && length(var.vault_admin_username) >= 3
    error_message = "Username must be at least 3 characters and contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "vault_jwt_auth_backend_description" {
  type        = string
  description = "(Optional) The description of the JWT auth backend for HCP Terraform."
  default     = "JWT authentication method for HCP Terraform."
}

variable "vault_jwt_auth_backend_path" {
  type        = string
  description = "(Optional) Path to mount the JWT/OIDC auth backend for HCP Terraform."
  default     = "jwt_hcp"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.vault_jwt_auth_backend_path))
    error_message = "JWT auth backend path must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "vault_namespace" {
  type        = string
  description = "(Optional) Vault namespace. Required for HCP workspace authentication."
  default     = "admin"

  validation {
    condition     = length(var.vault_namespace) > 0
    error_message = "Vault namespace cannot be empty."
  }
}

variable "vault_userpass_auth_backend_description" {
  type        = string
  description = "(Optional) A description of the userpass auth method."
  default     = "Userpass authentication method for administrative access."
}

variable "vault_userpass_auth_backend_path" {
  type        = string
  description = "(Optional) The path to mount the userpass auth method."
  default     = "userpass-admin"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.vault_userpass_auth_backend_path))
    error_message = "Auth backend path must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "vault_variable_set_id" {
  type        = string
  description = "(Optional) The ID of the variable set for Vault authentication variables."
  default     = null

  validation {
    condition     = var.vault_variable_set_id == null || can(regex("^varset-[a-zA-Z0-9]+$", var.vault_variable_set_id))
    error_message = "Variable set ID must be in the format 'varset-xxxxxxxxxxxxx' where x is alphanumeric, or null."
  }
}
