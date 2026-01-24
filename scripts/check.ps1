# Simple Pre-Deployment Check
# Validates that everything is ready for deployment

Write-Host "`n===============================================" -ForegroundColor Cyan
Write-Host "   Pre-Deployment Validation Check" -ForegroundColor Cyan
Write-Host "===============================================`n" -ForegroundColor Cyan

$allGood = $true

# Check required files
Write-Host "Checking required files..." -ForegroundColor Yellow

$files = @(
    "docker-compose.yml",
    ".env.production",
    "backend\Dockerfile",
    "nginx\nginx.conf"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  [OK] $file" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $file" -ForegroundColor Red
        $allGood = $false
    }
}

# Check Docker
Write-Host "`nChecking Docker..." -ForegroundColor Yellow
try {
    $null = docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Docker is running" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] Docker is not running" -ForegroundColor Red
        $allGood = $false
    }
} catch {
    Write-Host "  [ERROR] Docker not found" -ForegroundColor Red
    $allGood = $false
}

# Check .env.production
Write-Host "`nChecking configuration..." -ForegroundColor Yellow
if (Test-Path ".env.production") {
    $envContent = Get-Content .env.production -Raw
    
    if ($envContent -match "your_production_private_key_here") {
        Write-Host "  [WARNING] .env.production has placeholder values" -ForegroundColor Yellow
        Write-Host "  Update VERIFIER_PRIVATE_KEY before deploying" -ForegroundColor Yellow
    } else {
        Write-Host "  [OK] .env.production is configured" -ForegroundColor Green
    }
} else {
    Write-Host "  [ERROR] .env.production not found" -ForegroundColor Red
    $allGood = $false
}

# Check Flutter
Write-Host "`nChecking Flutter..." -ForegroundColor Yellow
try {
    $null = flutter --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Flutter is installed" -ForegroundColor Green
    } else {
        Write-Host "  [WARNING] Flutter command failed" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  [WARNING] Flutter not found" -ForegroundColor Yellow
}

# Summary
Write-Host "`n===============================================" -ForegroundColor Cyan

if ($allGood) {
    Write-Host "   Status: READY FOR DEPLOYMENT" -ForegroundColor Green
    Write-Host "===============================================`n" -ForegroundColor Cyan
    Write-Host "Run deployment with: .\scripts\deploy.ps1`n" -ForegroundColor White
} else {
    Write-Host "   Status: ISSUES FOUND" -ForegroundColor Red
    Write-Host "===============================================`n" -ForegroundColor Cyan
    Write-Host "Please fix the errors above before deploying`n" -ForegroundColor Red
    exit 1
}
