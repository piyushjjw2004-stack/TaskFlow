# TaskFlow — Final Capstone Submission Guide

## Purpose

TaskFlow is a containerized task-management platform used to demonstrate the full eight-week DevOps internship curriculum.

## Requirement coverage

1. **DevOps & Git:** CALMS, feature branches, PR workflow and Git-managed declarative configuration.
2. **Linux & Docker:** Bash operational scripts, multi-stage images, non-root containers, networking and volumes.
3. **Compose & CI/CD:** multi-container Compose stack and GitHub Actions CI/CD.
4. **Security & IaC:** secure container settings, Trivy HIGH/CRITICAL gates and modular Terraform.
5. **Advanced IaC & Configuration:** S3 remote state/locking, Terraform workspaces and Ansible roles/playbooks.
6. **Kubernetes:** Deployments, Services, StatefulSet/PVC, Ingress, HPA, Helm and Kustomize.
7. **Observability & SRE:** Prometheus, Grafana, ServiceMonitor, alerts, metrics-server, SLI/SLO and self-healing.
8. **Integrated Capstone:** ECR/EKS delivery, DevSecOps, FinOps controls and AIOps-assisted incident triage.

## Canonical production architecture

```text
Git / PR
  -> GitHub Actions CI
  -> Tests + IaC validation
  -> Trivy
  -> Docker build
  -> ECR (immutable Git SHA)
  -> EKS
  -> Helm
  -> Alembic migration
  -> Kubernetes
  -> Prometheus / Grafana / HPA
  -> Smoke test
```

Infrastructure and application lifecycles are intentionally separate: Terraform provisions infrastructure, while the application pipeline deploys immutable application images to the existing EKS cluster.

## GitOps boundary

Kubernetes, Helm and Terraform configuration are version-controlled and reviewed through Git. This is GitOps-aligned declarative delivery; the project does not claim an Argo CD/Flux reconciliation controller.

## AIOps boundary

The project provides deterministic operational triage and a human-approved remediation boundary. It does not misrepresent a rule-based script as autonomous AI.

## Submission rule

Do not include local environments, secrets, databases or caches. Run `make capstone-validate` in Linux and complete `docs/submission-evidence.md` against the actual runtime before grading.
