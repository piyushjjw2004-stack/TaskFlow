# GitOps Practices in TaskFlow

TaskFlow uses Git as the source of truth for application and infrastructure configuration. The production deployment is CI/CD-driven rather than controller-based GitOps.

## GitOps-aligned practices

- Kubernetes and Helm manifests are declarative and version-controlled.
- Changes are introduced through pull requests.
- Production images use immutable Git SHA tags instead of `latest`.
- Infrastructure changes are reviewed through Terraform plans.
- Rollbacks use a previous immutable image/chart revision.
- Secrets are supplied at deployment time and are not committed.

## Boundary

This repository does **not** claim Argo CD/Flux-style continuous reconciliation. GitHub Actions is the deployment orchestrator. If the internship requires a GitOps controller specifically, Argo CD can be introduced as a separate deployment mode without running two competing production deployment controllers.
