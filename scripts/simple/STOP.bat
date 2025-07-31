@echo off
title Hospital App - Simple Stop
color 0C

echo.
echo ========================================
echo    HOSPITAL APP - SIMPLE STOP
echo ========================================
echo.
echo Stopping application...
echo.

docker-compose -f ../docker/docker-compose.dev.yml down

echo.
echo ========================================
echo    Application stopped successfully!
echo ========================================
echo.
echo To start again, double-click START.bat
echo.
pause
