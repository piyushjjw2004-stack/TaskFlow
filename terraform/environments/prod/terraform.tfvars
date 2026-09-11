aws_region          = "us-east-1"
environment         = "prod"
vpc_cidr            = "10.1.0.0/16"
cluster_name        = "taskflow-prod-eks"
node_instance_types = ["t3.large"]
min_node_count      = 3
max_node_count      = 10


# Optional: set the pre-created GitHub Actions OIDC deployment role ARN.
github_deploy_role_arn = ""

enable_monthly_budget     = false
monthly_budget_usd        = 100
budget_notification_email = ""
