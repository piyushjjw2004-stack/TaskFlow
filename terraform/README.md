# TaskFlow Infrastructure as Code (Terraform)

TaskFlow uses modular Terraform to provision AWS networking, EKS, ECR and IAM.

## Architecture

- Multi-AZ VPC with public/private subnets, IGW and NAT.
- EKS control plane and managed node group.
- ECR repositories with immutable image tags and scan-on-push.
- Optional GitHub Actions deployment-role EKS access entry and ECR push policy.

## Remote state

Remote state is implemented with an S3 backend using native Terraform S3 state locking (`use_lockfile = true`, Terraform >= 1.10). The state bucket is created once by `terraform/bootstrap-state`.

```bash
cd terraform/bootstrap-state
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply

cd ../environments/prod
cp backend.hcl.example backend.hcl
# replace the bucket name with the bootstrap output
terraform init -backend-config=backend.hcl
terraform plan
```

Never commit `backend.hcl` if it contains account-specific configuration or credentials.

## Validation

```bash
terraform fmt -recursive
cd environments/dev
terraform init -backend=false
terraform validate
terraform plan
```

`terraform apply` is intentionally manual because it creates billable AWS resources.
