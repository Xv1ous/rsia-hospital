@echo off
title Hospital App - Update Admin Password
color 0E

echo.
echo ========================================
echo    HOSPITAL APP - UPDATE ADMIN PASSWORD
echo ========================================
echo.

echo Updating admin password with provided encrypted value...
echo.

REM Update admin password with the provided encrypted value
docker exec hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital -e "UPDATE users SET password='$2a$12$lLKRwSUbB7NQOOr6pL.ysO7c1sss.9qpZYIi2Tpigo.Z6GsjNYuL.' WHERE username='admin';"

if %errorlevel% equ 0 (
    echo ✅ Admin password updated successfully!
    echo.
    echo Updated admin information:
    docker exec hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital -e "SELECT id, username, role FROM users WHERE username='admin';"
    echo.
    echo 📝 Note: You may need to restart the application for changes to take effect.
) else (
    echo ❌ Failed to update admin password!
    pause
    exit /b 1
)

echo.
pause
