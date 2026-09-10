# TaskFlow Security Architecture

## DevSecOps Pipeline
1. **Application Security Tests**: Pytest authentication and authorization regression tests, including cross-user task access protection.
2. **Dependency & Container Scanning**: Trivy scanner integrated into GitHub Actions CI pipeline scanning container images and filesystem for vulnerabilities.
3. **Secret Isolation**: Secrets managed via Environment variables and Kubernetes `Secret` objects, excluded from Git.
4. **Least Privilege**: Production Dockerfiles run under non-root user `appuser` (UID 1001). Pods configured with restricted `securityContext`.


## Secret Handling

- Backend `SECRET_KEY` and `DATABASE_URL` are required environment settings; no insecure application fallback is used.
- Kubernetes runtime secrets are expected to be created out-of-band; example manifests contain placeholders only.
- `.env` and Terraform state files are excluded by the root `.gitignore`.
- Development examples are templates and must be replaced before real deployment.

## Authorization

Task resources are always queried using the authenticated user's ID. Regression tests verify that another authenticated user cannot read or modify those resources.
