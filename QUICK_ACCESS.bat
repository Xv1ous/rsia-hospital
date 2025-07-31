@echo off
title Hospital App - Quick Access
color 0B

echo.
echo ========================================
echo    HOSPITAL APP - QUICK ACCESS
echo ========================================
echo.
echo Choose an option:
echo.
echo [1] Start Application
echo [2] Stop Application
echo [3] View Application Status
echo [4] View Application Logs
echo [5] Open Documentation
echo [6] Open Simple Guide
echo [7] Exit
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" (
    echo.
    echo Starting application...
    call scripts\simple\START.bat
) else if "%choice%"=="2" (
    echo.
    echo Stopping application...
    call scripts\simple\STOP.bat
) else if "%choice%"=="3" (
    echo.
    echo Checking application status...
    docker-compose -f docker/docker-compose.dev.yml ps
    echo.
    pause
) else if "%choice%"=="4" (
    echo.
    echo Opening application logs...
    docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app
) else if "%choice%"=="5" (
    echo.
    echo Opening documentation...
    start docs\
) else if "%choice%"=="6" (
    echo.
    echo Opening simple guide...
    start docs\README_SIMPLE.md
) else if "%choice%"=="7" (
    echo.
    echo Goodbye!
    exit /b 0
) else (
    echo.
    echo Invalid choice. Please try again.
    pause
    call QUICK_ACCESS.bat
)
