# TaskFlow Capstone Refinement Report

This repository is the refined version of `Project4 (4).zip`, aligned to the internship Weeks 1–8 capstone requirements.

## Refinements in this version

- Fixed Terraform IAM policy syntax and formatted the affected configuration.
- Added a dedicated EKS control-plane security group and attached the worker-node security group through an EC2 launch template.
- Explicitly enabled EKS API + ConfigMap authentication so GitHub Actions EKS access entries can be used.
- Added the AWS EBS CSI managed add-on and required IAM policy for persistent PostgreSQL storage.
- Fixed the Makefile command help quoting and added Makefile validation to `scripts/validate.sh`.
- Hardened Prometheus alert expressions against zero-request division.
- Kept Prometheus ServiceMonitor discovery across namespaces and a single production ServiceMonitor owner (Helm).
- Kept immutable Git-SHA image tags for production deployment and ECR lifecycle cleanup.
- Retained Terraform S3 remote state, native state locking, environment roots, and the explicit workspace demonstration.
- Retained Helm migration hooks, PostgreSQL persistence, HPA, PDB, Ingress, Prometheus/Grafana, FinOps controls and AIOps-assisted triage.
- Added `docs/runtime-validation.md` with the commands and live evidence required before grading.
- Added `docs/final-capstone-status.md` with the Week 1–8 compliance mapping.
- Removed duplicate unused Dockerfiles.
- Removed local virtual environments, `node_modules`, `.env`, SQLite database, Python caches and other generated artifacts from the submission package.

## Architecture boundary

Terraform provisions AWS infrastructure. GitHub Actions deploys application releases to the existing EKS cluster. Helm is the canonical production application deployment path; Kustomize remains available for declarative dev/teaching deployments. Ansible is intentionally demonstrated against self-managed Linux lab hosts rather than pretending to manage EKS managed nodes.

## Validation limitation

The repository has been statically checked for shell syntax, YAML/JSON structure, Python compilation and Makefile execution in this environment. The final live proof still requires a Linux/AWS environment with Terraform, Helm, kubectl, Ansible, Docker, an EKS cluster, GitHub OIDC and the configured secrets. Those runtime results must not be fabricated in the submission.
