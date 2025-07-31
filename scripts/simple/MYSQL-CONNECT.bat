@echo off
title Hospital App - MySQL Connect
color 0E

echo.
echo ========================================
echo    HOSPITAL APP - MYSQL CONNECT
echo ========================================
echo.
echo Connecting to MySQL database...
echo Database: hospital
echo Username: hospital_user
echo Password: hospital_pass
echo.
echo Type 'exit' to quit MySQL
echo.

docker exec -it hospital-mysql-dev mysql -u hospital_user -phospital_pass hospital
