#!/bin/bash

# Hospital Database Initialization Script
# This script resets the database and loads fresh data

echo "🏥 Hospital Database Initialization"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose file exists
if [ ! -f "docker/docker-compose.dev.yml" ]; then
    print_error "docker-compose.dev.yml not found. Please run this script from the project root."
    exit 1
fi

echo ""
echo "[1/5] Stopping containers..."
docker-compose -f docker/docker-compose.dev.yml down

echo ""
echo "[2/5] Removing existing database volume..."
docker volume rm docker_mysql_data_dev 2>/dev/null || true

echo ""
echo "[3/5] Starting containers with fresh database..."
docker-compose -f docker/docker-compose.dev.yml up -d

echo ""
echo "[4/5] Waiting for database to be ready..."
sleep 30

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
for i in {1..30}; do
    if docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysqladmin ping -h localhost -u hospital_user --silent; then
        print_status "MySQL is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        print_error "MySQL failed to start within 30 seconds"
        exit 1
    fi
    sleep 2
done

echo ""
echo "[5/5] Verifying data..."
sleep 10

# Verify data was loaded correctly
echo "Checking data counts..."

# Check doctors
DOCTOR_COUNT=$(docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -s -N -e "SELECT COUNT(*) FROM doctor;")
echo "Doctors: $DOCTOR_COUNT"

# Check schedules
SCHEDULE_COUNT=$(docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -s -N -e "SELECT COUNT(*) FROM doctor_schedule;")
echo "Schedules: $SCHEDULE_COUNT"

# Check services
SERVICE_COUNT=$(docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -s -N -e "SELECT COUNT(*) FROM services;")
echo "Services: $SERVICE_COUNT"

# Check news
NEWS_COUNT=$(docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -s -N -e "SELECT COUNT(*) FROM news;")
echo "News: $NEWS_COUNT"

# Check reviews
REVIEW_COUNT=$(docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -s -N -e "SELECT COUNT(*) FROM reviews;")
echo "Reviews: $REVIEW_COUNT"

# Check appointments
APPOINTMENT_COUNT=$(docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -s -N -e "SELECT COUNT(*) FROM appointments;")
echo "Appointments: $APPOINTMENT_COUNT"

# Check users
USER_COUNT=$(docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -s -N -e "SELECT COUNT(*) FROM users;")
echo "Users: $USER_COUNT"

echo ""
echo "🎉 Database initialization completed!"
echo ""
echo "Application URL: http://localhost:8080"
echo "Admin Login: admin / admin123"
echo "MySQL Access: localhost:3307 (user: hospital_user, password: hospital_pass)"
echo ""
echo "Use './scripts/simple/mysql-access.sh' for database management"
echo "Use './scripts/simple/backup-db.sh' to create backups"
