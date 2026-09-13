# TaskFlow Capstone Submission Evidence

This document records the evidence for the completed DevOps internship capstone.

The project was validated using local Docker/Compose, Docker Desktop Kubernetes, Prometheus/Grafana, GitHub Actions, and local/CI tooling.

AWS ECR/EKS live deployment was intentionally not performed because an AWS account with billing activation was not used.

## Final Evidence Matrix

| Requirement | Evidence | Status |
| --- | --- | --- |
| Git workflow | Git repository, branch workflow, commits and GitHub Actions integration | ✅ Complete |
| Linux | `scripts/linux-ops-demo.sh` and `make capstone-validate` executed successfully in Ubuntu WSL | ✅ Complete |
| Docker | Backend/frontend images, multi-stage builds and non-root runtime configuration validated | ✅ Complete |
| Compose | Docker Compose stack started successfully; backend, frontend and PostgreSQL health checks passed | ✅ Complete |
| CI | GitHub Actions CI completed successfully | ✅ Complete |
| Trivy | Patched backend image scanned locally with 0 HIGH/CRITICAL vulnerabilities; GitHub security workflow passed | ✅ Complete |
| Terraform | Terraform formatting and validation covered by repository/CI validation | ✅ Complete |
| Workspaces | Terraform workspace configuration validated | ✅ Complete |
| Ansible | Ansible playbook syntax validation covered by CI | ✅ Complete |
| Kubernetes | Deployments, Services, StatefulSet, PVC, Ingress and migration job validated on Docker Desktop Kubernetes | ✅ Complete |
| Helm | Helm chart configuration/template validation completed | ✅ Complete |
| Kustomize | Dev/prod Kustomize rendering and dev deployment validated | ✅ Complete |
| Prometheus | TaskFlow backend ServiceMonitor created and two backend targets reported `up` | ✅ Complete |
| Grafana | TaskFlow dashboard loaded with HTTP throughput, P95 latency, 5xx errors and business metrics | ✅ Complete |
| HPA | Backend HPA configured for CPU/memory targets and live metrics were observed | ✅ Complete |
| Self-healing | Backend pod deleted and Kubernetes automatically recreated a healthy replacement | ✅ Complete |
| FinOps | GitHub Actions Infracost cost-review workflow completed successfully | ✅ Complete |
| AIOps | Alert triage helper executed against Prometheus alerts and produced severity/prioritized investigation guidance | ✅ Complete |
| End-to-end AWS CD | ECR → EKS live deployment and AWS smoke test | ⚠️ Not performed |

## Runtime Evidence

### Docker Compose

The local Compose environment was successfully started and validated.

Validated services:

- PostgreSQL — healthy
- Backend — healthy
- Frontend — healthy

The TaskFlow application was exercised through the frontend, including task creation, search, filtering, status changes and persistence after refresh.

### Kubernetes

Docker Desktop Kubernetes was used for local runtime validation.

Validated:

- Kubernetes cluster
- Backend Deployment
- Frontend Deployment
- PostgreSQL StatefulSet
- PostgreSQL PVC
- Kubernetes Services
- Database migration job
- Ingress
- Metrics Server
- Horizontal Pod Autoscaler
- Kustomize dev overlay

The TaskFlow frontend was accessed through the Kubernetes Ingress using:

`taskflow.local`

### HPA

The backend HPA was observed using live metrics.

Example observed state:

- CPU: approximately `2% / 70%`
- Memory: approximately `26% / 80%`
- Minimum replicas: `2`
- Maximum replicas: `5`
- Current replicas: `2`

A scale-up load test was not used as the primary evidence; the evidence is based on the functioning metrics-server/HPA configuration and live metrics.

### Monitoring

Prometheus successfully scraped two TaskFlow backend targets through the TaskFlow ServiceMonitor.

TaskFlow application metrics included:

- `taskflow_http_requests_total`
- `taskflow_http_request_duration_seconds`
- `taskflow_tasks_total`
- `taskflow_active_users_total`

Grafana displayed:

- HTTP Throughput
- P95 Request Latency
- HTTP 5xx Error Rate
- Registered Active Users

### Alerting

The following TaskFlow alerts were deployed and evaluated:

- `TaskFlowBackendDown`
- `TaskFlowHighErrorRate`
- `TaskFlowHighLatency`

The validated alert state showed these rules as inactive/healthy under normal conditions.

### Self-Healing

A backend Kubernetes pod was manually deleted.

Kubernetes automatically recreated the backend pod and returned the replacement to a healthy `Running` state.

This demonstrates Kubernetes workload self-healing.

### Security

The backend runtime image was patched using current Debian packages.

A local Trivy scan of the resulting backend image reported:

`HIGH,CRITICAL vulnerabilities: 0`

The GitHub Container & Code Security workflow also completed successfully.

### FinOps

The FinOps workflow was changed to perform a Terraform/Infracost cost review without requiring live AWS credentials.

The GitHub Actions FinOps Cost Review workflow completed successfully after configuring the Infracost API key as a GitHub secret.

This validates the cost-review automation, not live AWS billing behavior.

### AIOps

`scripts/aiops_insights.py` was executed against Prometheus alert data.

The script:

1. Reads Prometheus alerts.
2. Sorts alerts by severity.
3. Classifies operational symptoms.
4. Produces deterministic investigation guidance.
5. Does not automatically modify infrastructure.

This provides a safe human-approved AIOps/incident-triage boundary.

## AWS Limitation

Live AWS deployment was not performed.

The following production path therefore remains unvalidated in a live AWS environment:

```text
GitHub Actions
    ↓
Docker build
    ↓
Amazon ECR
    ↓
Amazon EKS
    ↓
Helm
    ↓
Alembic migration
    ↓
Kubernetes
    ↓
Smoke test

```

This is an environment limitation, not a claim of successful AWS runtime deployment.

The repository contains the Terraform/EKS/ECR delivery configuration and the CI/CD workflow, but no live AWS deployment evidence is claimed.

## Final Statement

TaskFlow Weeks 1–8 implementation and available runtime/CI validation are complete.

Local runtime validation covered Docker Compose and Kubernetes, including application behavior, persistence, Ingress, HPA metrics, Prometheus, Grafana, alerting and self-healing.

GitHub Actions validation covered CI, security scanning and FinOps cost review.

AWS ECR/EKS live deployment was intentionally not performed because an activated AWS billing environment was not used.

No AWS deployment, ECR push, EKS deployment or AWS smoke test should be represented as completed evidence.
