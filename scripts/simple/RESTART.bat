@echo off
title Hospital App - Restart
color 0B

echo.
echo ========================================
echo    HOSPITAL APP - RESTART
echo ========================================
echo.

echo 🔄 Restarting application containers...
docker-compose -f docker/docker-compose.dev.yml restart

echo.
echo ✅ Application restarted successfully!

echo.
echo ⏳ Waiting for containers to be ready...
timeout /t 10 /nobreak >nul

echo.
echo 📊 Container Status:
docker-compose -f docker/docker-compose.dev.yml ps

echo.
echo 🌐 Application URL: http://localhost:8080
echo 👤 Admin Login: admin / admin123
echo 🗄️ MySQL Access: localhost:3307 (user: hospital_user, password: hospital_pass)

echo.
echo 💡 Use 'scripts\simple\MYSQL-ACCESS.bat' for database management
echo 💡 Use 'scripts\simple\BACKUP-DB.bat' to create backups

echo.
pause
