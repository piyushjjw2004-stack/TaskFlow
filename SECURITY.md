# Security Policy & Guidelines — TaskFlow Platform

## Security Overview
TaskFlow follows strict DevSecOps engineering principles to safeguard application state and cloud infrastructure.

## Security Practices Implemented
1. **No Committed Secrets**: Environment variables (`.env`) are strictly excluded via `.gitignore`. Template values are provided via `.env.example`.
2. **Password Security**: Passwords are hashed using `passlib[bcrypt]` with dynamic salts before storage.
3. **Authentication**: JWT token authentication with expiration and signature verification.
4. **Non-Root Containers**: Docker containers run as unprivileged users (`appuser`, UID 1001) in production.
5. **Vulnerability Scanning**: Automated Trivy container image and filesystem vulnerability scans in GitHub Actions CI (`severity: HIGH,CRITICAL`).
6. **Kubernetes Security Context**: Restricted pod capabilities, `readOnlyRootFilesystem` where applicable, and explicit non-root execution.
7. **Infrastructure Security**: AWS Security Groups limiting ingress traffic exclusively to required ports (HTTP 80, HTTPS 443, API 8000).

## Vulnerability Reporting
To report security vulnerabilities, please open an issue in the GitHub repository or contact `security@taskflow.dev`.
