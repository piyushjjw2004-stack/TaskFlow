# TaskFlow Deployment Guide

This guide separates local verification from the real AWS/EKS capstone path.

## 1. Local Docker

```bash
cp .env.example .env
docker compose up -d --build
# migrations run automatically as a Helm post-install/post-upgrade hook and are verified by the deployment smoke test
curl http://localhost:8000/api/health
```

Start local observability after the application stack is running:

```bash
docker compose -f docker-compose.monitoring.yml up -d
```

- Frontend: http://localhost:3000
- API docs: http://localhost:8000/api/docs
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3001

## 2. Local Kubernetes (Kind/Minikube)

Install the ingress controller, metrics-server and monitoring stack:

```bash
kind create cluster --name taskflow-cluster
./scripts/bootstrap-cluster.sh
```

Create the runtime secret without committing credentials:

```bash
export POSTGRES_PASSWORD='a-local-password'
export SECRET_KEY='a-local-secret-key-with-at-least-32-characters'
./scripts/create-k8s-secret.sh
```

Build local images and load them into Kind, then deploy the Helm chart using `--set` image repositories/tags or use a private registry.

## 3. AWS/EKS

### Provision infrastructure

First create the remote-state bucket once:

```bash
cd terraform/bootstrap-state
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

Copy the resulting bucket name into `terraform/environments/prod/backend.hcl`, then:

```bash
cd terraform/environments/prod
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

The EKS cluster name is exactly `taskflow-prod-eks`.

### Configure GitHub Actions

Create an AWS IAM role trusted by GitHub Actions OIDC and store its ARN as the repository secret `AWS_ROLE_ARN`. The GitHub runner must also have network access to the EKS Kubernetes API endpoint. With the default restricted `admin_allowed_cidrs`, use a self-hosted runner/bastion inside an approved network or explicitly configure an approved public CIDR; do not blindly open the Kubernetes API to the world. The role needs permission to push to the two ECR repositories and update/deploy the EKS workload. Also configure:

- `TASKFLOW_POSTGRES_PASSWORD`
- `TASKFLOW_SECRET_KEY`

The CD workflow then performs:

```text
Git push
  -> tests / security
  -> Docker build
  -> Trivy gate
  -> ECR
  -> EKS kubeconfig
  -> ingress-nginx + metrics-server
  -> Helm upgrade
  -> Alembic migration hook
  -> rollout verification
  -> smoke test
```

## 4. Kubernetes persistence

PostgreSQL is a StatefulSet with a PVC for the training/local path. On EKS, ensure the AWS EBS CSI driver and a suitable StorageClass are installed before using the PVC. For a real production system, move PostgreSQL to a managed database such as Amazon RDS.


## 5. Terraform workspace demonstration

The syllabus explicitly includes Terraform workspaces. Use the isolated demonstration root in `terraform/workspaces`:

```bash
cd terraform/workspaces
cp backend.hcl.example backend.hcl
# set the real state bucket
terraform init -backend-config=backend.hcl
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
terraform plan
terraform workspace select prod
terraform plan
```

The real production deployment continues to use separate environment roots so that production state and configuration remain explicitly isolated.
