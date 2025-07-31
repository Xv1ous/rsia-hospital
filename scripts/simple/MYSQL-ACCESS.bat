@echo off
title Hospital App - MySQL Access
color 0E

echo.
echo ========================================
echo    HOSPITAL APP - MYSQL ACCESS
echo ========================================
echo.
echo Choose an option:
echo.
echo [1] Connect to MySQL (Interactive)
echo [2] View Database Tables
echo [3] View Sample Data
echo [4] Backup Database
echo [5] Restore Database
echo [6] Reset Database
echo [7] Exit
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" (
    echo.
    echo Connecting to MySQL database...
    echo Database: hospital
    echo Username: hospital_user
    echo Password: hospital_pass
    echo.
    echo Type 'exit' to quit MySQL
    echo.
    docker exec -it -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital
) else if "%choice%"=="2" (
    echo.
    echo Showing database tables...
    echo.
    docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SHOW TABLES;"
    echo.
    pause
) else if "%choice%"=="3" (
    echo.
    echo Showing sample data from main tables...
    echo.
    echo === DOCTORS ===
    docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, name, specialization FROM doctor LIMIT 5;"
    echo.
    echo === APPOINTMENTS ===
    docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, patient_name, doctor_id, appointment_date FROM appointments LIMIT 5;"
    echo.
    echo === NEWS ===
    docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, title, created_at FROM news LIMIT 5;"
    echo.
    pause
) else if "%choice%"=="4" (
    echo.
    echo Creating database backup...
    for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
    set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
    set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
    set "datestamp=%YYYY%%MM%%DD%_%HH%%Min%%Sec%"
    set "BACKUP_FILE=hospital_backup_%datestamp%.sql"
    docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysqldump -u hospital_user hospital > "%BACKUP_FILE%"
    echo Backup saved as: %BACKUP_FILE%
    echo.
    pause
) else if "%choice%"=="5" (
    echo.
    echo Available backup files:
    dir *.sql | findstr hospital_backup
    echo.
    set /p backup_file="Enter backup filename (or press Enter to cancel): "
    if not "%backup_file%"=="" (
        if exist "%backup_file%" (
            echo Restoring database from %backup_file%...
            docker exec -i -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital < "%backup_file%"
            echo Database restored successfully!
        ) else (
            echo Invalid filename or file not found.
        )
    )
    echo.
    pause
) else if "%choice%"=="6" (
    echo.
    echo ⚠️  WARNING: This will reset the database!
    echo All data will be lost and replaced with initial data.
    echo.
    set /p confirm="Are you sure? Type 'yes' to continue: "
    if "%confirm%"=="yes" (
        echo Resetting database...
        docker-compose -f docker/docker-compose.dev.yml down
        docker volume rm docker_mysql_data_dev 2>nul
        docker-compose -f docker/docker-compose.dev.yml up -d
        echo Database reset successfully!
    ) else (
        echo Database reset cancelled.
    )
    echo.
    pause
) else if "%choice%"=="7" (
    echo.
    echo Goodbye!
    exit /b 0
) else (
    echo.
    echo Invalid choice. Please try again.
    pause
    call MYSQL-ACCESS.bat
)
