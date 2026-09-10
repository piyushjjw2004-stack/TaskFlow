# Capstone Requirement Mapping

| Syllabus requirement | TaskFlow implementation | Status |
|---|---|---|
| DevOps/CALMS | `docs/devops-culture.md`, CALMS mapping, automation | 🟢 |
| Git workflows / PRs | Branching guide, PR template, CI on PRs; protected branches/history must be demonstrated in GitHub | 🟢* |
| GitOps practices | Declarative version-controlled manifests, immutable releases and PR workflow; no Argo CD/Flux controller | 🟡 |
| Linux / shell | Bash scripts, Makefile, CLI workflows | 🟢 |
| Docker | Multi-stage images, non-root runtime, health checks | 🟢 |
| Docker Compose | App + PostgreSQL + network + persistent volume + migration | 🟢 |
| GitHub Actions CI | Tests, frontend checks, IaC validation, Docker build | 🟢 |
| Trivy / DevSecOps | Filesystem + image scanning with HIGH/CRITICAL failure gate | 🟢 |
| Terraform basics | VPC, EKS, ECR, IAM, security groups | 🟢 |
| Terraform modules | Networking/security/compute modules | 🟢 |
| Remote state | S3 backend bootstrap + native state locking | 🟢* |
| Terraform workspaces | Dedicated `terraform/workspaces` demonstration | 🟢* |
| Ansible | Roles, inventories and playbooks for Linux/self-managed lab hosts | 🟢 |
| Kubernetes | Deployments, Services, StatefulSet, PVC, Secret, ConfigMap, Ingress, HPA, PDB, migration | 🟢 |
| Helm | Canonical production chart with migration hook and ServiceMonitor | 🟢 |
| Kustomize | Base + dev/prod alternative deployment path | 🟢 |
| Scaling | HPA + metrics-server + bounded EKS node autoscaling | 🟢* |
| Prometheus | kube-prometheus-stack + ServiceMonitor + alerts | 🟢* |
| Grafana | Dashboard + provisioning via kube-prometheus-stack | 🟢* |
| SRE | Health/readiness, SLIs/SLOs, alerts and error-budget guidance | 🟢 |
| FinOps | AWS tagging, ECR lifecycle, bounded capacity, optional AWS Budget and Infracost workflow | 🟢* |
| AIOps trends | Deterministic AIOps-ready triage plus safe AI integration design | 🟡 |
| Full CI/CD integration | GitHub Actions: test → scan → build → ECR → EKS → Helm → migration → verify → smoke test | 🟢* |

`*` Requires the external cloud/GitHub/Kubernetes prerequisites described in `docs/deployment.md`.

## Canonical production flow

```text
Developer
  -> Pull Request
  -> CI tests + IaC validation
  -> Trivy security gate
  -> Docker build
  -> ECR (immutable Git SHA)
  -> EKS
  -> Helm deployment
  -> PostgreSQL migration
  -> Kubernetes health checks
  -> Prometheus / Grafana
  -> HPA scaling
  -> smoke test / troubleshooting
```

## Deployment strategy

Helm is the canonical production deployment path used by GitHub Actions on EKS. Kustomize is retained as an alternative local/teaching deployment path and is not mixed into the Helm release.


## Readiness boundary

The application readiness endpoint checks database connectivity so the Helm `--wait` phase cannot deadlock the migration hook. The separate `/api/ready/schema` endpoint verifies the Alembic schema after the migration hook completes.
