aws_region          = "us-east-1"
environment         = "dev"
vpc_cidr            = "10.0.0.0/16"
cluster_name        = "taskflow-dev-eks"
node_instance_types = ["t3.medium"]
min_node_count      = 2
max_node_count      = 3


# Optional: set the pre-created GitHub Actions OIDC deployment role ARN.
github_deploy_role_arn = ""

enable_monthly_budget     = false
monthly_budget_usd        = 100
budget_notification_email = ""
