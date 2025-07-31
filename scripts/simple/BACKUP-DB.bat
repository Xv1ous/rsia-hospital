@echo off
title Hospital App - Backup Database
color 0E

echo.
echo ========================================
echo    HOSPITAL APP - BACKUP DATABASE
echo ========================================
echo.

REM Create backup filename with timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "datestamp=%YYYY%%MM%%DD%_%HH%%Min%%Sec%"
set "BACKUP_FILE=hospital_backup_%datestamp%.sql"

echo Creating database backup...
echo Backup file: %BACKUP_FILE%
echo.

REM Create backup
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysqldump -u hospital_user hospital > "%BACKUP_FILE%"

if %errorlevel% equ 0 (
    echo ✅ Backup created successfully!
    echo 📁 File: %BACKUP_FILE%
    for %%A in ("%BACKUP_FILE%") do echo 📊 Size: %%~zA bytes
) else (
    echo ❌ Backup failed!
    pause
    exit /b 1
)

echo.
pause
