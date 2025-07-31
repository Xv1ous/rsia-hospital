@echo off
echo ========================================
echo    Hospital App - Windows Deployment
echo ========================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not running!
    echo Please start Docker Desktop first.
    pause
    exit /b 1
)

echo [1/4] Building application...
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo [2/4] Building Docker image...
docker build -f Dockerfile.simple -t hospital-app:latest .
if %errorlevel% neq 0 (
    echo ERROR: Docker build failed!
    pause
    exit /b 1
)

echo [3/4] Starting containers...
docker-compose -f docker-compose.dev.yml up -d
if %errorlevel% neq 0 (
    echo ERROR: Failed to start containers!
    pause
    exit /b 1
)

echo [4/4] Waiting for services to be ready...
timeout /t 30 /nobreak >nul

echo.
echo ========================================
echo    Deployment Complete!
echo ========================================
echo.
echo Application URL: http://localhost:8080
echo Database: localhost:3307
echo Admin Login: admin / admin123
echo.
echo To view logs: docker-compose logs -f hospital-app
echo To stop: docker-compose down
echo.
pause
