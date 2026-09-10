# TaskFlow Automated Project Verification Script (PowerShell)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Running TaskFlow Full Verification Suite " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$Failed = $false

# 1. Backend Pytest Execution
Write-Host "`n[1/3] Testing Backend API with Pytest..." -ForegroundColor Yellow
try {
    python -m pytest backend/tests --tb=short
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] All Backend API Pytest tests passed cleanly!" -ForegroundColor Green
    } else {
        Write-Host "[FAILURE] Backend API Pytest tests failed." -ForegroundColor Red
        $Failed = $true
    }
} catch {
    Write-Host "[ERROR] Could not execute pytest: $_" -ForegroundColor Red
    $Failed = $true
}

# 2. Frontend TypeScript & Vite Check
Write-Host "`n[2/3] Checking Frontend TypeScript & Vite Build..." -ForegroundColor Yellow
try {
    npm --prefix frontend run lint
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] Frontend TypeScript type check passed with 0 errors!" -ForegroundColor Green
    } else {
        Write-Host "[FAILURE] Frontend TypeScript lint failed." -ForegroundColor Red
        $Failed = $true
    }
} catch {
    Write-Host "[ERROR] Could not execute npm lint: $_" -ForegroundColor Red
    $Failed = $true
}

# 3. Directory Structure Verification
Write-Host "`n[3/3] Verifying DevOps Infrastructure Files..." -ForegroundColor Yellow
$RequiredPaths = @(
    "backend/Dockerfile",
    "frontend/Dockerfile",
    "docker-compose.yml",
    ".github/workflows/ci.yml",
    ".github/workflows/security.yml",
    "terraform/main.tf",
    "ansible/playbooks/site.yml",
    "kubernetes/base/backend-deployment.yaml",
    "helm/taskflow/Chart.yaml",
    "monitoring/prometheus/prometheus.yml"
)

foreach ($Path in $RequiredPaths) {
    if (Test-Path $Path) {
        Write-Host "  [OK] Found $Path" -ForegroundColor DarkGreen
    } else {
        Write-Host "  [MISSING] $Path not found!" -ForegroundColor Red
        $Failed = $true
    }
}

Write-Host "`n=========================================" -ForegroundColor Cyan
if ($Failed) {
    Write-Host " Verification Suite Completed with ERRORS " -ForegroundColor Red
    exit 1
} else {
    Write-Host " All TaskFlow Verification Checks PASSED! " -ForegroundColor Green
    exit 0
}
