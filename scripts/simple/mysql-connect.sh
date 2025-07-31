#!/bin/bash

echo ""
echo "========================================"
echo "    HOSPITAL APP - MYSQL CONNECT"
echo "========================================"
echo ""
echo "Connecting to MySQL database..."
echo "Database: hospital"
echo "Username: hospital_user"
echo "Password: hospital_pass"
echo ""
echo "Type 'exit' to quit MySQL"
echo ""

docker exec -it -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital
