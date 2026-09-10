output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.vpc_id
}

output "eks_cluster_endpoint" {
  description = "Kubernetes API server endpoint for EKS cluster"
  value       = module.compute.cluster_endpoint
}

output "eks_cluster_name" {
  description = "Name of the deployed EKS cluster"
  value       = module.compute.cluster_name
}

output "backend_ecr_repository_url" {
  description = "ECR repository URL for backend container images"
  value       = module.security.backend_ecr_repository_url
}

output "frontend_ecr_repository_url" {
  description = "ECR repository URL for frontend container images"
  value       = module.security.frontend_ecr_repository_url
}
