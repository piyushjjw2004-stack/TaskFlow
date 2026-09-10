#!/usr/bin/env bash
set -euo pipefail

echo "== TaskFlow Capstone validation =="

for required in backend frontend terraform ansible kubernetes helm monitoring .github/workflows; do
  test -e "$required" || { echo "[FAIL] Missing: $required"; exit 1; }
done

if find . -type d \( -name .venv -o -name node_modules -o -name __pycache__ \) -print -quit | grep -q .; then
  echo "[FAIL] Local dependency/cache directories must not be included in the submission."
  exit 1
fi
if find . -type f \( -name .env -o -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' -o -name '*.pyc' \) -print -quit | grep -q .; then
  echo "[FAIL] Local secrets/database/cache artifacts must not be included in the submission."
  exit 1
fi

if find . -type f -path './docker/*/Dockerfile' -print -quit | grep -q .; then
  echo "[FAIL] Duplicate Dockerfiles under docker/ should not be included; use backend/Dockerfile and frontend/Dockerfile."
  exit 1
fi

for f in scripts/*.sh; do
  bash -n "$f"
done

python -m compileall -q backend/app backend/tests scripts/*.py

python - <<'PY2'
import glob, json
from pathlib import Path
import yaml

files = (glob.glob('.github/workflows/*.yml') +
         glob.glob('kubernetes/**/*.yaml', recursive=True) +
         glob.glob('monitoring/**/*.yml', recursive=True) +
         glob.glob('monitoring/**/*.yaml', recursive=True) +
         glob.glob('docker-compose*.yml'))
for name in files:
    with open(name, encoding='utf-8') as fh:
        list(yaml.safe_load_all(fh))

for name in glob.glob('monitoring/**/*.json', recursive=True):
    with open(name, encoding='utf-8') as fh:
        json.load(fh)
print('YAML/JSON validation: OK')
PY2

if command -v make >/dev/null 2>&1; then make help >/dev/null; fi
if command -v docker >/dev/null 2>&1; then
  docker compose -f docker-compose.yml config >/dev/null
  docker compose -f docker-compose.prod.yml config >/dev/null
  docker compose -f docker-compose.monitoring.yml config >/dev/null
else
  echo "[INFO] Docker not installed; GitHub Actions performs Docker validation."
fi
if command -v terraform >/dev/null 2>&1; then
  terraform fmt -check -recursive terraform
  (cd terraform/environments/dev && terraform init -backend=false && terraform validate)
  (cd terraform/environments/prod && terraform init -backend=false && terraform validate)
  (cd terraform/workspaces && terraform init -backend=false && terraform validate)
else
  echo "[INFO] Terraform not installed; GitHub Actions performs Terraform validation."
fi

if command -v helm >/dev/null 2>&1; then
  helm lint ./helm/taskflow -f ./helm/taskflow/values-prod.yaml
  helm template taskflow ./helm/taskflow -f ./helm/taskflow/values-prod.yaml \
    --set secret.create=true \
    --set secret.postgresPassword=ci-only-password \
    --set secret.secretKey=ci-only-secret-key-012345678901234567890123456789 >/dev/null
else
  echo "[INFO] Helm not installed; GitHub Actions performs Helm validation."
fi

if command -v kubectl >/dev/null 2>&1; then
  kubectl kustomize kubernetes/overlays/prod >/dev/null
else
  echo "[INFO] kubectl not installed; GitHub Actions performs Kustomize validation."
fi

if command -v ansible-playbook >/dev/null 2>&1; then
  (cd ansible && ansible-playbook playbooks/site.yml --syntax-check)
else
  echo "[INFO] Ansible not installed; GitHub Actions/runtime environment performs syntax validation."
fi

echo "== TaskFlow Capstone static validation passed =="
