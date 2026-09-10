# TaskFlow CI/CD Pipeline Documentation

TaskFlow separates application delivery from infrastructure lifecycle management while keeping both automated and reviewable.

## Workflows

1. **Continuous Integration (`ci.yml`)**
   - Runs backend tests against PostgreSQL.
   - Runs frontend TypeScript checks and production build.
   - Checks Terraform formatting and validates the environment/workspace configurations.
   - Lints/renders Helm and builds Kustomize manifests.
   - Builds both Docker images.

2. **Security (`security.yml`)**
   - Runs Trivy filesystem/dependency scans.
   - Builds and scans backend/frontend images.
   - Fails on configured `HIGH`/`CRITICAL` vulnerabilities (excluding unfixed findings).

3. **Infrastructure as Code (`infrastructure.yml`)**
   - Runs on Terraform pull requests and manual dispatch.
   - Initializes the real S3 remote state backend when AWS/state-bucket secrets are configured.
   - Runs `terraform fmt`, `validate` and `plan`.
   - `terraform apply` is available only through an explicit manual workflow dispatch.
   - Dev/prod infrastructure changes therefore remain separate from routine application releases.

4. **Continuous Delivery (`cd.yml`)**
   - Uses GitHub OIDC to assume an AWS IAM role; no long-lived AWS keys are stored.
   - Builds and security-scans images.
   - Pushes immutable Git-SHA tags to Amazon ECR.
   - Connects to EKS.
   - Installs/updates ingress-nginx, metrics-server and kube-prometheus-stack.
   - Creates the runtime Kubernetes Secret from GitHub Secrets.
   - Deploys the canonical Helm release with atomic rollback behavior.
   - Runs the Alembic migration hook.
   - Registers TaskFlow alert rules.
   - Verifies rollouts and runs HTTP smoke tests.

## Required GitHub repository secrets

- `AWS_ROLE_ARN` — IAM role trusted by GitHub Actions OIDC.
- `TASKFLOW_POSTGRES_PASSWORD` — runtime PostgreSQL password.
- `TASKFLOW_SECRET_KEY` — application signing secret (32+ characters).
- `TF_STATE_BUCKET` — S3 bucket created by `terraform/bootstrap-state` for the infrastructure workflow.

The AWS role should be scoped to the TaskFlow ECR repositories and EKS deployment operations. Terraform can optionally create the EKS access entry and ECR push policy when `github_deploy_role_arn` is supplied.

## Deployment separation

```text
Infrastructure workflow
  Terraform plan/apply
       |
       v
      AWS/EKS
       |
       +------------------+
                          |
Application workflow       |
  Test -> Trivy -> ECR ----+
             -> Helm -> EKS
             -> Migration -> Smoke test
```

This separation avoids running `terraform apply` on every application commit while still demonstrating Terraform as an automated part of the overall DevOps lifecycle.
