@echo off
echo.
echo ========================================================
echo    Local Deployment - Proof of Culture
echo    Running Backend and Frontend on Windows
echo ========================================================
echo.

REM Check Python
echo Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.10+
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)
echo [OK] Python found

echo.
echo ========================================================
echo Setting up Backend...
echo ========================================================

cd backend

REM Create virtual environment if it doesn't exist
if not exist ".venv" (
    echo Creating Python virtual environment...
    python -m venv .venv
)

REM Activate virtual environment and install dependencies
echo Installing dependencies...
call .venv\Scripts\activate.bat
pip install -r requirements.txt

if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo ========================================================
echo Starting Backend Server...
echo ========================================================
echo.
echo Backend will run at: http://localhost:8000
echo API Documentation at: http://localhost:8000/docs
echo.
echo Press Ctrl+C to stop the server
echo.

REM Start backend server
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
