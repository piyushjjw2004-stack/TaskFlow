variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "node_security_group_id" {
  type = string
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "min_node_count" {
  type    = number
  default = 2
}

variable "max_node_count" {
  type    = number
  default = 5
}

variable "admin_allowed_cidrs" {
  description = "CIDR blocks allowed to access the public EKS Kubernetes API endpoint"
  type        = list(string)
  default     = ["203.0.113.0/32"]
  validation {
    condition     = length(var.admin_allowed_cidrs) > 0
    error_message = "At least one administrative CIDR must be provided."
  }
}

variable "github_deploy_role_arn" {
  type    = string
  default = ""
}

variable "cluster_security_group_id" {
  type        = string
  description = "Security group attached to the EKS control plane"
}
