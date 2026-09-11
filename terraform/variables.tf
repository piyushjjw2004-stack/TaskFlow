variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "Name of the EKS Kubernetes cluster"
  type        = string
  default     = "taskflow-cluster"
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "min_node_count" {
  description = "Minimum count of EKS worker nodes"
  type        = number
  default     = 2
}

variable "max_node_count" {
  description = "Maximum count of EKS worker nodes for scaling"
  type        = number
  default     = 5
}

variable "admin_allowed_cidrs" {
  description = "CIDR blocks allowed to access the public EKS Kubernetes API endpoint"
  type        = list(string)

  validation {
    condition     = length(var.admin_allowed_cidrs) > 0
    error_message = "admin_allowed_cidrs must contain at least one CIDR block."
  }
}

variable "github_deploy_role_arn" {
  description = "Optional pre-created IAM role ARN assumed by GitHub Actions through OIDC for ECR/EKS deployment"
  type        = string
  default     = ""
}

variable "enable_monthly_budget" {
  description = "Create an AWS monthly cost budget for this environment"
  type        = bool
  default     = false
}

variable "monthly_budget_usd" {
  description = "Monthly AWS budget threshold in USD"
  type        = number
  default     = 100
  validation {
    condition     = var.monthly_budget_usd > 0
    error_message = "monthly_budget_usd must be greater than zero."
  }
}

variable "budget_notification_email" {
  description = "Email address for AWS Budget notifications when the budget is enabled"
  type        = string
  default     = ""
}
