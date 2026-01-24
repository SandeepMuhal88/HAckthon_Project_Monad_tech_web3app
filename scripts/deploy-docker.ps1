# Docker Deployment Script for Windows
# This script builds and starts all services in Docker containers

Write-Host "🐳 Starting Docker Deployment..." -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker status..." -ForegroundColor Yellow
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
}
catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    Write-Host "   Download Docker Desktop from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Building and starting services..." -ForegroundColor Yellow
Write-Host "This may take 5-10 minutes on first run..." -ForegroundColor Gray
Write-Host ""

# Build and start services
docker-compose up --build -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Deployment successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Your services are now running at:" -ForegroundColor Cyan
    Write-Host "   Frontend (Flutter Web):  http://localhost:3000" -ForegroundColor White
    Write-Host "   Backend API:             http://localhost:8000" -ForegroundColor White
    Write-Host "   API Documentation:       http://localhost:8000/docs" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Useful commands:" -ForegroundColor Cyan
    Write-Host "   View logs:     docker-compose logs -f" -ForegroundColor Gray
    Write-Host "   Stop services: docker-compose down" -ForegroundColor Gray
    Write-Host "   Restart:       docker-compose restart" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📊 Checking service health..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    docker-compose ps
}
else {
    Write-Host ""
    Write-Host "❌ Deployment failed. Check the error messages above." -ForegroundColor Red
    Write-Host "   Run 'docker-compose logs' to see detailed errors." -ForegroundColor Yellow
    exit 1
}
