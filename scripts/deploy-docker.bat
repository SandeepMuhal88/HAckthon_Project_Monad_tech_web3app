@echo off
REM Docker Deployment Script for Windows (Batch version)
echo.
echo 🐳 Starting Docker Deployment...
echo.

REM Check if Docker is running
echo Checking Docker status...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop.
    echo    Download Docker Desktop from: https://www.docker.com/products/docker-desktop
    exit /b 1
)

echo ✅ Docker is running
echo.

echo Building and starting services...
echo This may take 5-10 minutes on first run...
echo.

REM Navigate to project root
cd /d "%~dp0\.."

REM Build and start services
docker-compose up --build -d

if %errorlevel% equ 0 (
    echo.
    echo ✅ Deployment successful!
    echo.
    echo 🌐 Your services are now running at:
    echo    Frontend ^(Flutter Web^):  http://localhost:3000
    echo    Backend API:             http://localhost:8000
    echo    API Documentation:       http://localhost:8000/docs
    echo.
    echo 📋 Useful commands:
    echo    View logs:     docker-compose logs -f
    echo    Stop services: docker-compose down
    echo    Restart:       docker-compose restart
    echo.
    echo 📊 Checking service health...
    timeout /t 5 /nobreak >nul
    docker-compose ps
) else (
    echo.
    echo ❌ Deployment failed. Check the error messages above.
    echo    Run 'docker-compose logs' to see detailed errors.
    exit /b 1
)
