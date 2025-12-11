variable "jwt_bound_issuer" {
  type        = string
  description = "The value against which to match the iss claim in a JWT"
  default     = "https://app.terraform.io"
}

variable "jwt_oidc_discovery_url" {
  type        = string
  description = "The OIDC Discovery URL, without any .well-known component (base path)"
  default     = "https://app.terraform.io"
}

variable "jwt_tfc_audience" {
  type        = string
  description = "The audience value for HCP Terraform JWT tokens"
  default     = "vault.workload.identity"
}
