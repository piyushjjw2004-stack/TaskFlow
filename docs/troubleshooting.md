# TaskFlow Troubleshooting Guide

## 1. Backend Pod in CrashLoopBackOff
- **Symptom**: `kubectl get pods -n taskflow` shows `taskflow-backend-xxx` in `CrashLoopBackOff`.
- **Diagnosis Command**: `kubectl logs -n taskflow deployment/taskflow-backend --previous`
- **Common Causes**:
  - PostgreSQL container not ready: Check `kubectl logs -n taskflow statefulset/postgres`.
  - Missing secret key or invalid database URL: Verify `taskflow-secret` and `taskflow-config`.

## 2. Ingress 404 Not Found
- **Symptom**: Accessing `http://taskflow.local` returns NGINX 404.
- **Diagnosis Command**: `kubectl describe ingress taskflow-ingress -n taskflow`
- **Fix**: Verify `/etc/hosts` contains `127.0.0.1 taskflow.local` and NGINX Ingress Controller is installed.

## 3. Database Connection Failed
- **Symptom**: `/api/ready` returns 503 `database: disconnected`.
- **Fix**: Verify Postgres credentials in `.env` or Kubernetes secret match the initialization database settings.
