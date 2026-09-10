#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:3000}"
API_URL="${API_URL:-http://localhost:8000}"

echo "Checking frontend..."
curl --fail --silent --show-error "$BASE_URL/health" >/dev/null
echo "Frontend: OK"

echo "Checking backend..."
curl --fail --silent --show-error "$API_URL/api/health" >/dev/null
echo "Backend: OK"
