# Pre-Deployment Validation Script
# Run this before deploying to catch common issues

param(
    [switch]$Quick = $false
)

$ErrorActionPreference = "Continue"
$issues = @()
$warnings = @()

function Write-Check {
    param([string]$Message)
    Write-Host "🔍 Checking: $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "  ✅ $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "  ❌ $Message" -ForegroundColor Red
    $script:issues += $Message
}

function Write-Warn {
    param([string]$Message)
    Write-Host "  ⚠️  $Message" -ForegroundColor Yellow
    $script:warnings += $Message
}

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host "  🔍 Pre-Deployment Validation" -ForegroundColor Blue
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host ""

# 1. Check required files
Write-Check "Required files exist"
$requiredFiles = @(
    "docker-compose.yml",
    ".env.production",
    "backend\Dockerfile",
    "backend\requirements.txt",
    "backend\app\main.py",
    "frontend\poc_engine\pubspec.yaml",
    "nginx\nginx.conf"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Pass "$file exists"
    } else {
        Write-Fail "$file is missing"
    }
}

# 2. Check .env.production
Write-Host ""
Write-Check ".env.production configuration"

if (Test-Path ".env.production") {
    $envContent = Get-Content .env.production -Raw
    
    # Check for placeholder values
    if ($envContent -match "your_production_private_key_here") {
        Write-Fail "VERIFIER_PRIVATE_KEY still has placeholder value"
    } else {
        Write-Pass "VERIFIER_PRIVATE_KEY is set"
    }
    
    if ($envContent -match "your-domain.com") {
        Write-Warn "Domain still has placeholder value (OK for localhost testing)"
    } else {
        Write-Pass "Domain is configured"
    }
    
    # Check for required variables
    $requiredVars = @("MONAD_RPC_URL", "VERIFIER_ADDRESS", "API_URL")
    foreach ($var in $requiredVars) {
        if ($envContent -match "$var=.+") {
            Write-Pass "$var is set"
        } else {
            Write-Fail "$var is not set"
        }
    }
} else {
    Write-Fail ".env.production file not found"
}

# 3. Check Docker
Write-Host ""
Write-Check "Docker environment"

try {
    $dockerVersion = docker --version
    Write-Pass "Docker installed: $dockerVersion"
    
    $null = docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Pass "Docker is running"
    } else {
        Write-Fail "Docker is not running - please start Docker Desktop"
    }
} catch {
    Write-Fail "Docker not found - please install Docker Desktop"
}

# 4. Check Flutter
Write-Host ""
Write-Check "Flutter environment"

try {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
    Write-Pass "Flutter installed: $flutterVersion"
    
    Push-Location "frontend\poc_engine"
    flutter pub get > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Pass "Flutter dependencies resolved"
    } else {
        Write-Warn "Flutter dependencies may have issues"
    }
    Pop-Location
} catch {
    Write-Fail "Flutter not found - please install Flutter SDK"
}

# 5. Check available ports
Write-Host ""
Write-Check "Port availability"

$portsToCheck = @(
    @{Port=80; Service="Nginx HTTP"},
    @{Port=443; Service="Nginx HTTPS"},
    @{Port=8000; Service="Backend API"}
)

foreach ($portCheck in $portsToCheck) {
    $port = $portCheck.Port
    $service = $portCheck.Service
    
    $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($connection) {
        if ($port -eq 443) {
            Write-Warn "Port $port ($service) is in use - SSL may not work"
        } else {
            Write-Fail "Port $port ($service) is already in use"
        }
    } else {
        Write-Pass "Port $port ($service) is available"
    }
}

# 6. Check backend code
if (-not $Quick) {
    Write-Host ""
    Write-Check "Backend code validation"
    
    Push-Location "backend"
    
    # Check if virtual environment exists
    if (Test-Path ".venv") {
        Write-Pass "Virtual environment found"
    } else {
        Write-Warn "No virtual environment (OK for Docker deployment)"
    }
    
    # Check main.py syntax
    try {
        python -m py_compile app\main.py 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Pass "Backend syntax valid"
        } else {
            Write-Fail "Backend has syntax errors"
        }
    } catch {
        Write-Warn "Could not validate Python syntax (Python may not be installed)"
    }
    
    Pop-Location
}

# 7. Check frontend code
if (-not $Quick) {
    Write-Host ""
    Write-Check "Frontend code validation"
    
    Push-Location "frontend\poc_engine"
    
    # Run flutter analyze
    Write-Host "  Running Flutter analyze (this may take a moment)..." -ForegroundColor Gray
    $analyzeOutput = flutter analyze 2>&1
    
    if ($analyzeOutput -match "No issues found") {
        Write-Pass "Flutter code has no issues"
    } else {
        Write-Warn "Flutter analyze found some issues - check manually"
    }
    
    Pop-Location
}

# 8. Check disk space
Write-Host ""
Write-Check "Disk space"

$drive = Get-PSDrive -Name ($PWD.Drive.Name)
$freeSpaceGB = [math]::Round($drive.Free / 1GB, 2)

if ($freeSpaceGB -gt 5) {
    Write-Pass "Sufficient disk space: ${freeSpaceGB}GB free"
} elseif ($freeSpaceGB -gt 2) {
    Write-Warn "Low disk space: ${freeSpaceGB}GB free"
} else {
    Write-Fail "Critically low disk space: ${freeSpaceGB}GB free"
}

# Summary
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host "  📊 Validation Summary" -ForegroundColor Blue
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host ""

if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "✅ All checks passed! Ready for deployment." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next step: Run deployment script" -ForegroundColor Cyan
    Write-Host "  .\scripts\deploy.ps1" -ForegroundColor White
    exit 0
} else {
    if ($issues.Count -gt 0) {
        Write-Host "❌ Found $($issues.Count) critical issue(s):" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "  • $issue" -ForegroundColor Red
        }
        Write-Host ""
    }
    
    if ($warnings.Count -gt 0) {
        Write-Host "⚠️  Found $($warnings.Count) warning(s):" -ForegroundColor Yellow
        foreach ($warning in $warnings) {
            Write-Host "  • $warning" -ForegroundColor Yellow
        }
        Write-Host ""
    }
    
    if ($issues.Count -gt 0) {
        Write-Host "❌ Please fix critical issues before deploying." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "⚠️  You may proceed, but review warnings first." -ForegroundColor Yellow
        exit 0
    }
}
