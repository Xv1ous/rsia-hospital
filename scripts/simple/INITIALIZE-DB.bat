@echo off
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

REM Verify initialization
echo [5/5] Verifying database initialization...
echo.

echo 📊 Database Tables:
docker exec hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital -e "SHOW TABLES;"
echo.

echo 👨‍⚕️ Doctors:
docker exec hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital -e "SELECT id, name, specialization FROM doctor LIMIT 5;"
echo.

echo 📅 Doctor Schedules:
docker exec hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital -e "SELECT id, name, day, time, specialization FROM doctor_schedule LIMIT 5;"
echo.

echo 📰 News:
docker exec hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital -e "SELECT id, title, published_at FROM news LIMIT 5;"
echo.

echo 🔧 Services:
docker exec hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital -e "SELECT id, name, description FROM services LIMIT 5;"
echo.

echo 👤 Users:
docker exec hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital -e "SELECT id, username, role FROM users;"
echo.

echo ========================================
echo    ✅ DATABASE INITIALIZED SUCCESSFULLY!
echo ========================================
echo.
echo 🌐 Application URL: http://localhost:8080
echo 👤 Admin Login: admin / (password from encrypted value)
echo.
echo 📊 Sample data has been loaded:
echo    - Doctors and schedules
echo    - News articles
echo    - Services
echo    - Admin user
echo.

pause
