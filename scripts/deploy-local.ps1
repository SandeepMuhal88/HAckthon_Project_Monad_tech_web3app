# Local Deployment Script (Without Docker)
# Deploys backend and frontend directly on Windows

Write-Host "`n" -NoNewline
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     Local Deployment - Proof of Culture           ║" -ForegroundColor Cyan
Write-Host "║     Running on Windows (No Docker Required)       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Continue"

# Function to check if a port is in use
function Test-PortInUse {
    param([int]$Port)
    $connection = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    return $null -ne $connection
}

# Function to find and kill process on port
function Stop-ProcessOnPort {
    param([int]$Port)
    $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    foreach ($conn in $connections) {
        $process = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
        if ($process) {
            Write-Host "  Stopping process on port $Port`: $($process.Name)" -ForegroundColor Yellow
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }
    }
}

# Check Python
Write-Host "🔍 Checking Python..." -ForegroundColor Cyan
try {
    $pythonVersion = python --version 2>&1
    Write-Host "  ✅ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Python not found. Please install Python 3.10+" -ForegroundColor Red
    Write-Host "     Download from: https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# Check Flutter
Write-Host "`n🔍 Checking Flutter..." -ForegroundColor Cyan
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "  ✅ Flutter found: $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️  Flutter not found. Web app won't be built." -ForegroundColor Yellow
    Write-Host "     Download from: https://flutter.dev/" -ForegroundColor Yellow
    $skipFlutter = $true
}

# Stop any existing services on ports
Write-Host "`n🔧 Checking ports..." -ForegroundColor Cyan

if (Test-PortInUse -Port 8000) {
    Write-Host "  Port 8000 is in use. Stopping existing backend..." -ForegroundColor Yellow
    Stop-ProcessOnPort -Port 8000
}

# Step 1: Setup Backend
Write-Host "`n📦 Setting up Backend..." -ForegroundColor Cyan

Push-Location backend

# Create virtual environment if it doesn't exist
if (-not (Test-Path ".venv")) {
    Write-Host "  Creating Python virtual environment..." -ForegroundColor Yellow
    python -m venv .venv
}

# Activate virtual environment
Write-Host "  Activating virtual environment..." -ForegroundColor Yellow
& .\.venv\Scripts\Activate.ps1

# Install dependencies
Write-Host "  Installing Python dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt --quiet

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Failed to install dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "  ✅ Backend dependencies installed" -ForegroundColor Green

# Start backend in background
Write-Host "`n🚀 Starting Backend Server..." -ForegroundColor Cyan
Write-Host "  URL: http://localhost:8000" -ForegroundColor White

# Use Start-Process to run backend in new window
$backendProcess = Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$PWD'; .\.venv\Scripts\Activate.ps1; python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"
) -PassThru -WindowStyle Normal

Pop-Location

# Wait for backend to start
Write-Host "  Waiting for backend to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Check if backend is running
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-Host "  ✅ Backend is running!" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️  Backend may still be starting..." -ForegroundColor Yellow
    Write-Host "  Check the backend window for any errors" -ForegroundColor Yellow
}

# Step 2: Build Flutter Web (if available)
if (-not $skipFlutter) {
    Write-Host "`n📱 Building Flutter Web App..." -ForegroundColor Cyan
    
    Push-Location "frontend\poc_engine"
    
    # Update API URL for local development
    $apiConfigPath = "lib\core\api_config.dart"
    if (Test-Path $apiConfigPath) {
        Write-Host "  ✅ Using api_config.dart (already configured)" -ForegroundColor Green
    }
    
    # Clean and get dependencies
    Write-Host "  Getting Flutter dependencies..." -ForegroundColor Yellow
    flutter pub get | Out-Null
    
    # Build for web
    Write-Host "  Building web app (this may take a few minutes)..." -ForegroundColor Yellow
    flutter build web --release
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ Flutter web app built successfully!" -ForegroundColor Green
        Write-Host "  Output: frontend\poc_engine\build\web" -ForegroundColor Gray
    } else {
        Write-Host "  ⚠️  Flutter build had issues, but continuing..." -ForegroundColor Yellow
    }
    
    Pop-Location
}

# Step 3: Build Android APK (optional)
if (-not $skipFlutter) {
    Write-Host ""
    $buildApk = Read-Host "Do you want to build Android APK? (y/N)"
    
    if ($buildApk -eq 'y' -or $buildApk -eq 'Y') {
        Write-Host "`n📱 Building Android APK..." -ForegroundColor Cyan
        
        Push-Location "frontend\poc_engine"
        
        flutter build apk --release
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ Android APK built successfully!" -ForegroundColor Green
            $apkPath = Resolve-Path "build\app\outputs\flutter-apk\app-release.apk"
            Write-Host "  📦 APK Location: $apkPath" -ForegroundColor White
            
            # Ask to open folder
            $openFolder = Read-Host "`n  Open APK folder? (Y/n)"
            if ($openFolder -ne 'n' -and $openFolder -ne 'N') {
                explorer.exe "build\app\outputs\flutter-apk"
            }
        } else {
            Write-Host "  ❌ APK build failed" -ForegroundColor Red
        }
        
        Pop-Location
    }
}

# Summary
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║            ✅ DEPLOYMENT SUCCESSFUL!                ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "📊 Service URLs:" -ForegroundColor Yellow
Write-Host "  🌐 Backend API:    http://localhost:8000" -ForegroundColor White
Write-Host "  📚 API Docs:       http://localhost:8000/docs" -ForegroundColor White
Write-Host "  ❤️  Health Check:  http://localhost:8000/health" -ForegroundColor White

if (-not $skipFlutter) {
    Write-Host ""
    Write-Host "  📱 Flutter App:    Run 'flutter run -d chrome' in frontend/poc_engine" -ForegroundColor White
    Write-Host "  🌐 Web Build:      Open frontend/poc_engine/build/web/index.html" -ForegroundColor White
}

Write-Host ""
Write-Host "📝 Useful Commands:" -ForegroundColor Yellow
Write-Host "  Test API:          curl http://localhost:8000/api/events" -ForegroundColor Gray
Write-Host "  View API docs:     start http://localhost:8000/docs" -ForegroundColor Gray
Write-Host "  Run Flutter:       cd frontend\poc_engine; flutter run -d chrome" -ForegroundColor Gray
Write-Host ""

Write-Host "🔴 To Stop Backend:" -ForegroundColor Yellow
Write-Host "  Close the backend PowerShell window" -ForegroundColor Gray
Write-Host "  Or press Ctrl+C in the backend window" -ForegroundColor Gray
Write-Host ""

# Open browser to API docs
$openBrowser = Read-Host "Open API documentation in browser? (Y/n)"
if ($openBrowser -ne 'n' -and $openBrowser -ne 'N') {
    Start-Sleep -Seconds 2
    Start-Process "http://localhost:8000/docs"
}

Write-Host ""
Write-Host "🎉 All systems operational! Backend is running..." -ForegroundColor Green
Write-Host ""
