# Terraform Workspaces Demonstration

The production deployment uses separate `terraform/environments/dev` and `terraform/environments/prod` roots for explicit environment isolation. This folder exists specifically to demonstrate the Terraform **workspace** feature required by the internship syllabus.

## Setup

1. Create the remote state bucket using `terraform/bootstrap-state`.
2. Copy `backend.hcl.example` to `backend.hcl` and set the bucket name.
3. Initialize:

```bash
terraform init -backend-config=backend.hcl
```

## Demonstration

```bash
terraform workspace list
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
terraform plan
terraform workspace select prod
terraform plan
```

The workspace is used to select the environment and therefore changes the CIDR, EKS cluster name and node sizing. Do **not** run `apply` in this demonstration against a shared AWS account unless the instructor explicitly asks for it.

For the real capstone production deployment, use the environment roots because they make production/dev state isolation explicit and reviewable.
