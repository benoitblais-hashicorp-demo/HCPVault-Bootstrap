output "platform_admin_password" {
  description = "Password for the platform-admin user in userpass-admin auth method"
  sensitive   = true
  value       = random_password.platform_admin_password.result
}

output "platform_admin_username" {
  description = "Username for the platform-admin user in userpass-admin auth method"
  value       = var.platform_admin_username
}

output "vault_admin_password" {
  description = "Password for the vault-admin user in userpass-admin auth method"
  sensitive   = true
  value       = random_password.vault_admin_password.result
}

output "vault_admin_username" {
  description = "Username for the vault-admin user in userpass-admin auth method"
  value       = var.vault_admin_username
}

output "userpass_auth_path" {
  description = "Path where the userpass authentication method is mounted"
  value       = vault_auth_backend.userpass.path
}

output "jwt_auth_path" {
  description = "Path where the JWT authentication method is mounted"
  value       = vault_jwt_auth_backend.jwt.path
}

output "jwt_role_hcp_terraform_vault" {
  description = "Name of the JWT role for HCP Terraform HCP Vault project"
  value       = vault_jwt_auth_backend_role.hcp_terraform_vault.role_name
}
