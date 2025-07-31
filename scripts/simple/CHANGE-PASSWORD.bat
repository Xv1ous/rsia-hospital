@echo off
title Hospital App - Change Password
color 0E

echo.
echo ========================================
echo    HOSPITAL APP - CHANGE PASSWORD
echo ========================================
echo.

echo Current users in database:
echo.
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, username, role FROM users;"
echo.

set /p username="Enter username to change password: "

if "%username%"=="" (
    echo ❌ Username cannot be empty!
    pause
    exit /b 1
)

REM Check if user exists
for /f %%i in ('docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT COUNT(*) FROM users WHERE username='%username%';" -s -N') do set USER_EXISTS=%%i

if %USER_EXISTS% equ 0 (
    echo ❌ User '%username%' not found in database!
    pause
    exit /b 1
)

echo.
echo Choose password type:
echo [1] Use provided encrypted password
echo [2] Enter new plain text password (will be encrypted)
echo.
set /p choice="Enter choice (1-2): "

if "%choice%"=="1" (
    echo.
    echo Using provided encrypted password:
    echo $2a$12$lLKRwSUbB7NQOOr6pL.ysO7c1sss.9qpZYIi2Tpigo.Z6GsjNYuL.
    echo.
    pause

    REM Update password with provided encrypted value
            docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "UPDATE users SET password='$2a$12$lLKRwSUbB7NQOOr6pL.ysO7c1sss.9qpZYIi2Tpigo.Z6GsjNYuL.' WHERE username='%username%';"

    if %errorlevel% equ 0 (
        echo ✅ Password updated successfully for user '%username%'!
    ) else (
        echo ❌ Failed to update password!
        pause
        exit /b 1
    )
) else if "%choice%"=="2" (
    echo.
    set /p new_password="Enter new password: "
    set /p confirm_password="Confirm new password: "

    if not "%new_password%"=="%confirm_password%" (
        echo ❌ Passwords do not match!
        pause
        exit /b 1
    )

    if "%new_password%"=="" (
        echo ❌ Password cannot be empty!
        pause
        exit /b 1
    )

    echo.
    echo ⚠️  Note: Plain text passwords will be encrypted by Spring Security
    echo The application will handle password encryption automatically.
    echo.
    pause

    REM For plain text password, we'll use a simple hash for now
    REM In production, Spring Security will handle the encryption
    echo %new_password% > temp_password.txt
    for /f %%h in ('certutil -hashfile temp_password.txt SHA256 ^| findstr /v "CertUtil" ^| findstr /v "SHA256"') do set HASHED_PASSWORD=%%h
    del temp_password.txt

            docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "UPDATE users SET password='%HASHED_PASSWORD%' WHERE username='%username%';"

    if %errorlevel% equ 0 (
        echo ✅ Password updated successfully for user '%username%'!
        echo 📝 Note: You may need to restart the application for changes to take effect.
    ) else (
        echo ❌ Failed to update password!
        pause
        exit /b 1
    )
) else (
    echo ❌ Invalid choice!
    pause
    exit /b 1
)

echo.
echo Updated user information:
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, username, role FROM users WHERE username='%username%';"
echo.

pause
