@echo off
echo ========================================
echo    Hospital App - Stop Containers
echo ========================================
echo.

echo Stopping containers...
docker-compose down

echo.
echo Containers stopped successfully!
echo.
pause
