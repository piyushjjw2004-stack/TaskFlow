terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"
    }
  }

  backend "s3" {
    # Configure with: terraform init -backend-config=backend.hcl
    # Terraform stores workspace states separately under the workspace prefix.
    key                  = "terraform.tfstate"
    use_lockfile          = true
    workspace_key_prefix = "taskflow/workspaces"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "TaskFlow"
      Environment = terraform.workspace
      ManagedBy   = "Terraform"
      StateModel  = "TerraformWorkspaceDemo"
    }
  }
}

locals {
  environment  = contains(["dev", "prod"], terraform.workspace) ? terraform.workspace : "dev"
  cluster_name = "taskflow-${local.environment}-workspace-eks"
}

module "taskflow" {
  source                    = "../"
  aws_region                = var.aws_region
  environment               = local.environment
  vpc_cidr                  = local.environment == "prod" ? "10.20.0.0/16" : "10.10.0.0/16"
  cluster_name              = local.cluster_name
  node_instance_types       = local.environment == "prod" ? ["t3.large"] : ["t3.medium"]
  min_node_count            = local.environment == "prod" ? 3 : 1
  max_node_count            = local.environment == "prod" ? 6 : 3
  admin_allowed_cidrs       = var.admin_allowed_cidrs
  github_deploy_role_arn    = var.github_deploy_role_arn
  enable_monthly_budget     = false
}

output "workspace" {
  value = terraform.workspace
}

output "cluster_name" {
  value = module.taskflow.eks_cluster_name
}
