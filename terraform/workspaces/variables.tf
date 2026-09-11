variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "admin_allowed_cidrs" {
  description = "Administrator CIDRs allowed to access the EKS API"
  type        = list(string)

  validation {
    condition     = length(var.admin_allowed_cidrs) > 0
    error_message = "admin_allowed_cidrs must contain at least one CIDR block."
  }
}

variable "github_deploy_role_arn" {
  description = "Optional GitHub Actions OIDC deployment role ARN"
  type        = string
  default     = ""
}
