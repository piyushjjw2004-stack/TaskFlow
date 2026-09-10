# Capstone Submission Evidence

Use this checklist to attach screenshots/links from the live environment. Do not claim a step passed until it has been executed.

| Requirement | Evidence to capture | Status |
|---|---|---|
| Git workflow | Feature branch, PR, merge/protection | ☐ |
| Linux | `scripts/linux-ops-demo.sh`, `make capstone-validate` | ☐ |
| Docker | Image build + non-root runtime | ☐ |
| Compose | `docker compose ps` + health checks | ☐ |
| CI | GitHub Actions successful run | ☐ |
| Trivy | Controlled HIGH/CRITICAL failure and passing scan | ☐ |
| Terraform | `plan`, modules, remote S3 state | ☐ |
| Workspaces | `terraform workspace list/select` | ☐ |
| Ansible | syntax check + role execution in lab | ☐ |
| Kubernetes | Pods, Services, PVC, Ingress | ☐ |
| Helm | install/upgrade/rollback + migration hook | ☐ |
| Kustomize | dev/prod build | ☐ |
| Prometheus | TaskFlow target is UP | ☐ |
| Grafana | Dashboard with traffic/latency/errors/business metrics | ☐ |
| HPA | Load test increases replicas | ☐ |
| Self-healing | Delete a backend pod and show replacement | ☐ |
| FinOps | Tags, lifecycle policy, budget/cost review | ☐ |
| AIOps | Alert triage helper + human approval boundary | ☐ |
| End-to-end CD | ECR → EKS → Helm → migration → smoke test | ☐ |

## Required final statement

Only after the above evidence is captured should the project be described as runtime-validated. The repository itself contains the implementation and validation commands; AWS credentials, GitHub OIDC, EKS and cloud resources are external prerequisites.
