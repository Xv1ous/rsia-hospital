@echo off
setlocal enabledelayedexpansion
title Hospital App - Quick Access
color 0B

:menu
cls
echo.
echo ========================================
echo    HOSPITAL APP - QUICK ACCESS
echo ========================================
echo.
echo Choose an option:
echo.
echo [1] Build Project (Create JAR file)
echo [2] Start Application
echo [3] Stop Application
echo [4] Restart Application
echo [5] View Application Status
echo [6] View Application Logs
echo [7] MySQL Database Access
echo [8] Initialize Database (Reset & Load Sample Data)
echo [9] Open Documentation
echo [10] Open Simple Guide
echo [11] Exit
echo.
set /p choice="Enter your choice (1-11): "

if "%choice%"=="1" (
    echo.
    echo Building project...
    call scripts\simple\BUILD.bat
    echo.
    pause
    goto menu
) else if "%choice%"=="2" (
    echo.
    echo Starting application...
    call scripts\simple\START.bat
    echo.
    pause
    goto menu
) else if "%choice%"=="3" (
    echo.
    echo Stopping application...
    call scripts\simple\STOP.bat
    echo.
    pause
    goto menu
) else if "%choice%"=="4" (
    echo.
    echo Restarting application...
    call scripts\simple\RESTART.bat
    echo.
    pause
    goto menu
) else if "%choice%"=="5" (
    echo.
    echo Checking application status...
    docker-compose -f docker/docker-compose.dev.yml ps
    echo.
    pause
    goto menu
) else if "%choice%"=="6" (
    echo.
    echo Opening application logs...
    docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app
) else if "%choice%"=="7" (
    echo.
    echo Opening MySQL Database Access...
    call scripts\simple\MYSQL-ACCESS.bat
    echo.
    pause
    goto menu
) else if "%choice%"=="8" (
    echo.
    echo Initializing database...
    call scripts\simple\INITIALIZE-DB.bat
    echo.
    pause
    goto menu
) else if "%choice%"=="9" (
    echo.
    echo Opening documentation...
    start docs\
    echo.
    pause
    goto menu
) else if "%choice%"=="10" (
    echo.
    echo Opening simple guide...
    start docs\README_SIMPLE.md
    echo.
    pause
    goto menu
) else if "%choice%"=="11" (
    echo.
    echo Goodbye!
    exit /b 0
) else (
    echo.
    echo Invalid choice. Please try again.
    pause
    goto menu
)
