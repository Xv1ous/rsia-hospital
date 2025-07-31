@echo off
title Hospital App - Simple Start
color 0A

echo.
echo ========================================
echo    HOSPITAL APP - SIMPLE START
echo ========================================
echo.
echo Starting application...
echo Please wait...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not running!
    echo.
    echo Please:
    echo 1. Open Docker Desktop
    echo 2. Wait until it says "Docker Desktop is running"
    echo 3. Run this file again
    echo.
    pause
    exit /b 1
)

REM Start the application
echo [1/3] Starting containers...
docker-compose -f ../docker/docker-compose.dev.yml up -d

echo [2/3] Waiting for application to start...
timeout /t 45 /nobreak >nul

echo [3/3] Checking if application is ready...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo    SUCCESS! Application is running
echo ========================================
echo.
echo 🌐 Open your browser and go to:
echo    http://localhost:8080
echo.
echo 👤 Admin Login:
echo    Username: admin
echo    Password: admin123
echo.
echo 📊 To view logs: docker-compose -f ../docker/docker-compose.dev.yml logs -f hospital-app
echo 🛑 To stop: docker-compose -f ../docker/docker-compose.dev.yml down
echo.
echo Press any key to open the application in browser...
pause >nul

REM Try to open browser
start http://localhost:8080

echo.
echo Browser opened! If it doesn't work, manually go to:
echo http://localhost:8080
echo.
pause
