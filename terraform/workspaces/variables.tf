variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "admin_allowed_cidrs" {
  description = "Administrator CIDRs allowed to access the EKS API"
  type        = list(string)
  default     = ["203.0.113.0/32"]
}

variable "github_deploy_role_arn" {
  description = "Optional GitHub Actions OIDC deployment role ARN"
  type        = string
  default     = ""
}
