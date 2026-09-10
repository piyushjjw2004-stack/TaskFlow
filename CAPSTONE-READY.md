# TaskFlow Capstone Readiness

## Status

The repository is prepared to satisfy the eight-week internship capstone at the source/configuration level. Runtime claims must be backed by the live validation checklist. It intentionally does not contain local dependency directories, secrets, databases, or generated caches.

## Requirement coverage

- Week 1: DevOps culture, CALMS, Git branching/PR workflow, declarative GitOps practices.
- Week 2: Linux/Bash operations, Docker images, networking and volumes.
- Week 3: Docker Compose and GitHub Actions CI/CD.
- Week 4: Secure containers, Trivy HIGH/CRITICAL gates, Terraform fundamentals.
- Week 5: Terraform modules, S3 remote state and locking, workspaces, Ansible roles/playbooks/inventory.
- Week 6: Kubernetes Deployments/Services/StatefulSet/PVC/Ingress/HPA/PDB, Helm and Kustomize.
- Week 7: Prometheus, Grafana, ServiceMonitor, metrics-server, HPA, alerts and SRE/SLI/SLO/error-budget practices.
- Week 8: Integrated delivery to ECR/EKS, DevSecOps, FinOps controls and AIOps-assisted incident triage.

## Canonical production path

Infrastructure lifecycle:

`GitHub -> Terraform plan/apply -> AWS VPC/EKS/ECR/EBS CSI`

Application lifecycle:

`GitHub -> CI -> Trivy -> Docker -> ECR -> EKS -> Helm -> migration -> rollout -> smoke test`

Observability:

`TaskFlow -> ServiceMonitor -> Prometheus -> Grafana/alerts -> HPA`

## Required live validation

Before grading, execute the runtime checklist in `docs/runtime-validation.md` on Linux/GitHub Actions and an actual Kubernetes/EKS environment. Prove the following live: CI, Trivy gate, Terraform plan, ECR push, Helm deployment, database migration, ingress, Prometheus/Grafana, HPA scaling, pod self-healing, and smoke tests.

## Important boundary

GitOps is implemented as Git-managed declarative infrastructure and release configuration; no Argo CD/Flux controller is claimed. AIOps is an assisted, human-approved triage layer rather than autonomous AI remediation.
