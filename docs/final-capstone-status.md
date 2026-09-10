# TaskFlow Final Capstone Status

This repository is structured to satisfy the internship capstone requirements across Weeks 1–8.

## Coverage

- Week 1: DevOps/CALMS, branching/PR workflow, GitOps-aligned declarative practices
- Week 2: Linux/Bash, Docker images, networking, volumes
- Week 3: Docker Compose, GitHub Actions CI/CD
- Week 4: secure containers, Trivy HIGH/CRITICAL gates, Terraform fundamentals
- Week 5: Terraform modules, S3 remote state and locking, workspaces, Ansible roles/playbooks
- Week 6: Kubernetes, Ingress, Helm, Kustomize, HPA, persistent PostgreSQL, migration Job
- Week 7: Prometheus, Grafana, metrics-server, scaling, alerts, SLI/SLO/error budget, self-healing
- Week 8: integrated CI/CD, ECR, EKS/IaC, DevSecOps, FinOps controls, AIOps-assisted triage

## Architecture decision

Terraform is the infrastructure pipeline; GitHub Actions deploys application releases to the existing EKS cluster. This avoids running `terraform apply` on every application commit. Helm is the canonical production application deployment path; Kustomize is retained for declarative dev/teaching deployments.

## AIOps boundary

The repository implements deterministic alert triage suggestions and a human-approval boundary. It does not falsely claim that a rule-based script is an autonomous AI remediation system.

## Before grading

Run `docs/runtime-validation.md` in a Linux environment and record evidence for CI, Trivy, Terraform, Helm/Kubernetes, Prometheus/Grafana, HPA and self-healing. AWS credentials, GitHub OIDC, remote-state bucket and cluster access are environment prerequisites, not repository secrets.
