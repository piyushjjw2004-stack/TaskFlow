# Internship Capstone Compliance Checklist

This checklist maps the repository to the eight-week internship syllabus and identifies what must be demonstrated in the live environment.

| Week | Requirement | Evidence | Live proof |
|---|---|---|---|
| 1 | DevOps + CALMS | `docs/devops-culture.md` | Explain CALMS mapping and PR workflow |
| 1 | Branching + PR | `.github/PULL_REQUEST_TEMPLATE.md`, `docs/git-workflow.md` | Show feature branch → PR → protected main/develop |
| 1 | GitOps practices | `docs/gitops.md`, declarative Helm/K8s | Explain Git as source of truth and immutable releases |
| 2 | Linux + shell | `scripts/*.sh`, `Makefile`, `scripts/linux-ops-demo.sh` | Run validation/health-check commands on Linux |
| 2 | Docker | `backend/Dockerfile`, `frontend/Dockerfile` | Build/run images and inspect containers |
| 2 | Networking + volumes | Compose files | Show service DNS and PostgreSQL persistence |
| 3 | Docker Compose | `docker-compose.yml` | Bring up the full local stack |
| 3 | GitHub Actions CI | `.github/workflows/ci.yml` | Show tests, IaC validation and image builds |
| 4 | Trivy | `security.yml`, `cd.yml` | Show HIGH/CRITICAL gate failing/passing |
| 4 | Terraform basics | `terraform/` | `plan` and explain modules/resources |
| 5 | Modules | `terraform/modules/*` | Explain reusable networking/security/compute modules |
| 5 | Remote state | `terraform/bootstrap-state`, S3 backends | Show S3 state and locking |
| 5 | Workspaces | `terraform/workspaces` | `terraform workspace list/select/plan` |
| 5 | Ansible | `ansible/` | `ansible-playbook --syntax-check` and explain roles |
| 6 | Kubernetes | `kubernetes/` | Pods, Deployments, Services, StatefulSet, PVC |
| 6 | Helm | `helm/taskflow/` | `helm lint`, install/upgrade and rollback |
| 6 | Kustomize | `kubernetes/overlays/` | Build dev/prod overlay |
| 6 | Ingress | Helm/K8s ingress | Show external HTTP routing |
| 7 | Prometheus | kube-prometheus-stack + ServiceMonitor | Show live TaskFlow metrics |
| 7 | Grafana | dashboard/provisioning | Show throughput, latency, errors and business metrics |
| 7 | Scaling | HPA + metrics-server | Generate load and show replica increase |
| 7 | Reliability | probes, PDB, alerts, SLO docs | Delete a pod and show self-healing |
| 8 | CI/CD integration | `cd.yml` + `infrastructure.yml` | Show code → scan → ECR → EKS → Helm → smoke test |
| 8 | DevSecOps | Trivy + K8s security contexts | Explain security gates and least privilege |
| 8 | FinOps | `finops.yml`, AWS tags/budget/ECR lifecycle | Show cost controls and optional Infracost |
| 8 | AIOps trends | `scripts/aiops_insights.py`, `docs/aiops.md` | Show alert triage and human approval boundary |

## Important distinction

A repository can contain every YAML file and still fail the capstone if the components are not connected. The final demonstration must prove the runtime path (the repository includes the commands; the live environment must be executed before grading):

```text
Git/PR
  -> CI
  -> tests
  -> Trivy
  -> Docker
  -> ECR
  -> EKS
  -> Helm
  -> migration
  -> health checks
  -> Prometheus
  -> Grafana/alerts
  -> HPA/self-healing
  -> smoke test
```

AWS credentials, GitHub OIDC, EKS access and an actual cluster are intentionally external prerequisites.
