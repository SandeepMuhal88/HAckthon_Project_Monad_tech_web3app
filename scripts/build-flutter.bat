@echo off
echo.
echo ========================================================
echo    Building Flutter Application
echo ========================================================
echo.

REM Check Flutter
echo Checking Flutter...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter not found. Please install Flutter SDK
    echo Download from: https://flutter.dev/
    pause
    exit /b 1
)
echo [OK] Flutter found

cd frontend\poc_engine

echo.
echo ========================================================
echo Getting Flutter Dependencies...
echo ========================================================
flutter pub get

echo.
echo ========================================================
echo Building Web App...
echo ========================================================
flutter build web --release

if errorlevel 1 (
    echo [ERROR] Flutter build failed
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Flutter web app built successfully!
echo Location: frontend\poc_engine\build\web
echo.

set /p buildApk="Do you want to build Android APK? (y/N): "
if /i "%buildApk%"=="y" (
    echo.
    echo ========================================================
    echo Building Android APK...
    echo ========================================================
    flutter build apk --release
    
    if errorlevel 0 (
        echo.
        echo [SUCCESS] Android APK built successfully!
        echo Location: build\app\outputs\flutter-apk\app-release.apk
        echo.
        set /p openFolder="Open APK folder? (Y/n): "
        if not "!openFolder!"=="n" if not "!openFolder!"=="N" (
            explorer build\app\outputs\flutter-apk
        )
    )
)

echo.
echo ========================================================
echo Build Complete!
echo ========================================================
echo.
echo To run the Flutter app:
echo   cd frontend\poc_engine
echo   flutter run -d chrome
echo.
pause
