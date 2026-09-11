module "taskflow_infrastructure" {
  source                    = "../../"
  aws_region                = var.aws_region
  environment               = "dev"
  vpc_cidr                  = "10.0.0.0/16"
  cluster_name              = "taskflow-dev-eks"
  node_instance_types       = ["t3.medium"]
  min_node_count            = 2
  max_node_count            = 3
  admin_allowed_cidrs       = var.admin_allowed_cidrs
  github_deploy_role_arn    = var.github_deploy_role_arn
  enable_monthly_budget     = var.enable_monthly_budget
  monthly_budget_usd        = var.monthly_budget_usd
  budget_notification_email = var.budget_notification_email
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

output "dev_eks_endpoint" {
  value = module.taskflow_infrastructure.eks_cluster_endpoint
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
  description = "Optional GitHub Actions IAM role ARN used for ECR/EKS deployment"
  type        = string
  default     = ""
}

variable "enable_monthly_budget" {
  type    = bool
  default = false
}

variable "monthly_budget_usd" {
  type    = number
  default = 100
}

variable "budget_notification_email" {
  type    = string
  default = ""
}
