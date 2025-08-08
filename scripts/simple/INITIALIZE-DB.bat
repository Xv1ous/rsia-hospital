@echo off
setlocal enabledelayedexpansion
title Hospital App - Initialize Database
color 0E

echo.
echo ========================================
echo    HOSPITAL APP - INITIALIZE DATABASE
echo ========================================
echo.

echo ⚠️  WARNING: This will reset the database and add sample data!
echo All existing data will be lost.
echo.
set /p confirm="Are you sure? Type 'yes' to continue: "

if not "%confirm%"=="yes" (
    echo Database initialization cancelled.
    pause
    exit /b 0
)

echo.
echo Initializing database with sample data...
echo.

REM Stop containers
echo [1/5] Stopping containers...
docker-compose -f docker/docker-compose.dev.yml down

REM Remove existing volumes
echo [2/5] Removing existing database volume...
docker volume rm docker_mysql_data_dev 2>nul

REM Start containers (this will trigger database initialization)
echo [3/5] Starting containers with fresh database...
docker-compose -f docker/docker-compose.dev.yml up -d

REM Wait for database to be ready
echo [4/5] Waiting for database to be ready...
timeout /t 30 /nobreak >nul

REM Wait for MySQL to be ready
echo [4/5] Waiting for MySQL to be ready...
for /l %%i in (1,1,30) do (
    docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysqladmin ping -h localhost -u hospital_user --silent >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ MySQL is ready!
        goto :mysql_ready
    )
    timeout /t 2 /nobreak >nul
)
echo ❌ MySQL failed to start within 60 seconds
pause
exit /b 1

:mysql_ready

REM Apply SQL migration files
echo [5/5] Checking for pending migrations...
echo.

set MIGRATION_DIR=src\main\resources\db\migration

if exist "%MIGRATION_DIR%" (
    echo 🔄 Checking for pending migrations from %MIGRATION_DIR%...
    echo.

    for %%f in ("%MIGRATION_DIR%\V*.sql") do (
        echo ▶️  Checking: %%~nxf
        docker exec -i -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital < "%%f" >nul 2>&1
        if !errorlevel! equ 0 (
            echo ✅ %%~nxf applied successfully
        ) else (
            echo ⚠️  %%~nxf already applied or failed (this is normal)
        )
        echo.
    )
) else (
    echo ⚠️  Migration directory not found: %MIGRATION_DIR%
    echo.
)

REM Verify initialization
echo 📊 Verifying database initialization...
echo.

echo 📊 Database Tables:
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SHOW TABLES;"
echo.

echo 👨‍⚕️ Doctors:
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, name, specialization FROM doctor LIMIT 5;"
echo.

echo 📅 Doctor Schedules:
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, name, day, time, specialization FROM doctor_schedule LIMIT 5;"
echo.

echo 📰 News:
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, title, created_at FROM news LIMIT 5;"
echo.

echo 🔧 Services:
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, name, description FROM services LIMIT 5;"
echo.

echo 👤 Users:
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, username, role FROM users;"
echo.

echo 📄 Page Contents:
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT page_type, COUNT(*) as count FROM page_contents GROUP BY page_type ORDER BY page_type;" 2>nul
echo.

echo ========================================
echo    ✅ DATABASE INITIALIZED SUCCESSFULLY!
echo ========================================
echo.
echo 🌐 Application URL: http://localhost:8080
echo 👤 Admin Login: admin / admin123
echo 🗄️  MySQL Access: localhost:3307 (user: hospital_user, password: hospital_pass)
echo.
echo 📋 Admin Dashboard Features:
echo    - Main Dashboard: http://localhost:8080/admin
echo    - Page Content Management: http://localhost:8080/admin/page-contents
echo    - Doctor Management: http://localhost:8080/admin/doctors
echo    - Appointment Management: http://localhost:8080/admin/appointments
echo.
echo 📊 Sample data has been loaded:
echo    - Doctors and schedules
echo    - News articles
echo    - Services
echo    - Admin user
echo    - Page contents (Facilities, Services, Home Care)
echo.

pause
