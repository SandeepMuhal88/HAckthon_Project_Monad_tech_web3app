# Production Deployment Script for Windows
# This script builds and deploys the Proof of Culture application

param(
    [switch]$SkipBuild = $false
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting Production Deployment..." -ForegroundColor Blue
Write-Host ""

# Function to print colored output
function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Check if .env.production exists
if (-not (Test-Path ".env.production")) {
    Write-Error-Custom ".env.production file not found!"
    Write-Info "Please create .env.production with your production configuration"
    exit 1
}

# Load environment variables from .env.production
Write-Info "Loading environment variables..."
Get-Content .env.production | ForEach-Object {
    if ($_ -match '^([^#].+?)=(.+)$') {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()
        [Environment]::SetEnvironmentVariable($name, $value, "Process")
    }
}
Write-Success "Environment variables loaded"

# Get API URL
$API_URL = $env:API_URL
if (-not $API_URL) {
    Write-Error-Custom "API_URL not set in .env.production"
    exit 1
}

# Step 1: Build Flutter Web App
if (-not $SkipBuild) {
    Write-Info "Building Flutter web application..."
    Push-Location "frontend\poc_engine"

    # Update API URL in api_service.dart
    Write-Info "Updating API URL to production: $API_URL"
    $apiServiceFile = "lib\services\api_service.dart"
    
    if (Test-Path $apiServiceFile) {
        # Backup original file
        Copy-Item $apiServiceFile "$apiServiceFile.bak" -Force
        
        # Read content and replace URL
        $content = Get-Content $apiServiceFile -Raw
        $content = $content -replace "http://localhost:8000/api", $API_URL
        Set-Content $apiServiceFile $content -NoNewline
        
        Write-Success "API URL updated to: $API_URL"
    } else {
        Write-Error-Custom "API service file not found: $apiServiceFile"
        Pop-Location
        exit 1
    }

    # Build Flutter web
    Write-Info "Cleaning Flutter build..."
    flutter clean
    
    Write-Info "Getting Flutter dependencies..."
    flutter pub get
    
    Write-Info "Building Flutter web (this may take a few minutes)..."
    flutter build web --release
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "Flutter build failed"
        Pop-Location
        exit 1
    }
    
    Write-Success "Flutter web build completed"
    Pop-Location
}

# Step 2: Build Android APK (Optional)
$buildAndroid = Read-Host "Do you want to build Android APK? (y/N)"
if ($buildAndroid -eq 'y' -or $buildAndroid -eq 'Y') {
    Write-Info "Building Android APK..."
    Push-Location "frontend\poc_engine"
    
    flutter build apk --release
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Android APK built successfully"
        Write-Info "APK location: $(Get-Location)\build\app\outputs\flutter-apk\app-release.apk"
    } else {
        Write-Error-Custom "Android build failed"
    }
    
    Pop-Location
}

# Step 3: Check Docker
Write-Info "Checking Docker..."
$dockerRunning = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Docker is not running. Please start Docker Desktop."
    exit 1
}
Write-Success "Docker is running"

# Step 4: Build Backend Docker Image
Write-Info "Building backend Docker image..."
docker build -t poc_backend:latest .\backend
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Failed to build backend Docker image"
    exit 1
}
Write-Success "Backend image built"

# Step 5: Stop existing containers
Write-Info "Stopping existing containers..."
docker-compose down 2>$null
Write-Success "Existing containers stopped"

# Step 6: Start services
Write-Info "Starting production services..."
docker-compose --env-file .env.production up -d

if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Failed to start services"
    docker-compose logs
    exit 1
}

# Wait for services to be healthy
Write-Info "Waiting for services to start (10 seconds)..."
Start-Sleep -Seconds 10

# Step 7: Check service health
Write-Info "Checking backend health..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Success "Backend is healthy"
    } else {
        throw "Unexpected status code: $($response.StatusCode)"
    }
} catch {
    Write-Error-Custom "Backend health check failed: $_"
    docker-compose logs backend
    exit 1
}

Write-Info "Checking Nginx..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost/health" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Success "Nginx is healthy"
    } else {
        throw "Unexpected status code: $($response.StatusCode)"
    }
} catch {
    Write-Error-Custom "Nginx health check failed: $_"
    docker-compose logs nginx
    exit 1
}

# Step 8: Display deployment info
Write-Host ""
Write-Success "🎉 Deployment successful!"
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "📊 Service URLs:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "🌐 Frontend App:    http://localhost/app/" -ForegroundColor White
Write-Host "🔧 API Endpoint:    http://localhost/api/" -ForegroundColor White
Write-Host "📚 API Docs:        http://localhost/docs" -ForegroundColor White
Write-Host "❤️  Health Check:   http://localhost/health" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""
Write-Host "📝 Useful Commands:" -ForegroundColor Yellow
Write-Host "  View logs:        docker-compose logs -f" -ForegroundColor White
Write-Host "  Stop services:    docker-compose down" -ForegroundColor White
Write-Host "  Restart:          docker-compose restart" -ForegroundColor White
Write-Host "  View status:      docker-compose ps" -ForegroundColor White
Write-Host ""
Write-Success "All systems operational! 🚀"

# Open browser
$openBrowser = Read-Host "Open application in browser? (Y/n)"
if ($openBrowser -ne 'n' -and $openBrowser -ne 'N') {
    Start-Process "http://localhost/app/"
}
