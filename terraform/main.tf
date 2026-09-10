module "networking" {
  source       = "./modules/networking"
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  cluster_name = var.cluster_name
}

module "security" {
  source                 = "./modules/security"
  environment            = var.environment
  vpc_id                 = module.networking.vpc_id
  vpc_cidr               = var.vpc_cidr
  github_deploy_role_arn = var.github_deploy_role_arn
  admin_allowed_cidrs    = var.admin_allowed_cidrs
}

module "compute" {
  source                    = "./modules/compute"
  environment               = var.environment
  cluster_name              = var.cluster_name
  public_subnet_ids         = module.networking.public_subnet_ids
  private_subnet_ids        = module.networking.private_subnet_ids
  node_security_group_id    = module.security.node_security_group_id
  cluster_security_group_id = module.security.cluster_security_group_id
  node_instance_types       = var.node_instance_types
  min_node_count            = var.min_node_count
  max_node_count            = var.max_node_count
  admin_allowed_cidrs       = var.admin_allowed_cidrs
  github_deploy_role_arn    = var.github_deploy_role_arn
}

resource "aws_budgets_budget" "monthly" {
  count        = var.enable_monthly_budget ? 1 : 0
  name         = "taskflow-${var.environment}-monthly"
  budget_type  = "COST"
  limit_amount = tostring(var.monthly_budget_usd)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.budget_notification_email]
  }

  lifecycle {
    precondition {
      condition     = var.budget_notification_email != ""
      error_message = "budget_notification_email is required when enable_monthly_budget is true."
    }
  }
}
