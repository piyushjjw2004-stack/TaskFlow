#!/usr/bin/env bash
set -euo pipefail

failures=0

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "[WARN] $1 is not installed; skipping its validation."; return 1; }
  return 0
}

# Always validate the repository's command entrypoint; this catches broken shell quoting early.
if require_cmd make; then
  make help >/dev/null || failures=$((failures+1))
fi

if require_cmd terraform; then
  (cd terraform/environments/dev && terraform init -backend=false && terraform validate) || failures=$((failures+1))
  (cd terraform/environments/prod && terraform init -backend=false && terraform validate) || failures=$((failures+1))
  (cd terraform/workspaces && terraform init -backend=false && terraform validate) || failures=$((failures+1))
fi

if require_cmd helm; then
  helm lint ./helm/taskflow -f ./helm/taskflow/values-prod.yaml || failures=$((failures+1))
  helm template taskflow ./helm/taskflow -f ./helm/taskflow/values-prod.yaml \
    --set secret.create=true \
    --set secret.postgresPassword=ci-only-password \
    --set secret.secretKey=ci-only-secret-key-012345678901234567890123456789 \
    >/tmp/taskflow-helm.yaml || failures=$((failures+1))
fi

if require_cmd kubectl; then
  kubectl kustomize kubernetes/overlays/prod >/tmp/taskflow-kustomize.yaml || failures=$((failures+1))
fi

if require_cmd ansible-playbook; then
  (cd ansible && ansible-playbook playbooks/site.yml --syntax-check) || failures=$((failures+1))
fi

if require_cmd pytest; then
  pytest backend/tests -v || failures=$((failures+1))
fi

if [ "$failures" -ne 0 ]; then
  echo "Validation completed with $failures failure(s)."
  exit 1
fi

echo "Validation completed successfully. Optional CLIs not installed in this environment were skipped."
