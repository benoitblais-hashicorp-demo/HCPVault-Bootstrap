output "opsadmin_password" {
  description = "Password for the opsadmin user in userpass-admin auth method"
  sensitive   = true
  value       = random_password.opsadmin_password.result
}

output "opsadmin_username" {
  description = "Username for the opsadmin user in userpass-admin auth method"
  value       = "opsadmin"
}

output "opsadmin_userpass_path" {
  description = "Path where the opsadmin userpass authentication method is mounted"
  value       = vault_auth_backend.admin_userpass.path
}

output "jwt_auth_path" {
  description = "Path where the JWT authentication method is mounted"
  value       = vault_jwt_auth_backend.jwt.path
}

output "jwt_role_hcp_terraform_vault" {
  description = "Name of the JWT role for HCP Terraform HCP Vault project"
  value       = vault_jwt_auth_backend_role.hcp_terraform_vault.role_name
}

output "superadmin_password" {
  description = "Password for the superadmin user in userpass-admin auth method"
  sensitive   = true
  value       = random_password.superadmin_password.result
}

output "superadmin_username" {
  description = "Username for the superadmin user in userpass-admin auth method"
  value       = "superadmin"
}
