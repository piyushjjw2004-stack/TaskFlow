variable "vpc_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "github_deploy_role_arn" {
  type    = string
  default = ""
}

variable "admin_allowed_cidrs" {
  type = list(string)
}
