#!/bin/bash

echo ""
echo "========================================"
echo "    HOSPITAL APP - INITIALIZE DATABASE"
echo "========================================"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "⚠️  WARNING: This will reset the database and add sample data!"
echo "All existing data will be lost."
echo ""
read -p "Are you sure? Type 'yes' to continue: " confirm

if [ "$confirm" != "yes" ]; then
    echo "Database initialization cancelled."
    exit 0
fi

echo ""
echo "Initializing database with sample data..."
echo ""

# Stop containers
echo "[1/5] Stopping containers..."
docker-compose -f "$PROJECT_ROOT/docker/docker-compose.dev.yml" down

# Remove existing volumes
echo "[2/5] Removing existing database volume..."
docker volume rm docker_mysql_data_dev 2>/dev/null || true

# Start containers (this will trigger database initialization)
echo "[3/5] Starting containers with fresh database..."
docker-compose -f "$PROJECT_ROOT/docker/docker-compose.dev.yml" up -d

# Wait for database to be ready
echo "[4/5] Waiting for database to be ready..."
sleep 30

# Verify initialization
echo "[5/5] Verifying database initialization..."
echo ""

echo "📊 Database Tables:"
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SHOW TABLES;"
echo ""

echo "👨‍⚕️ Doctors:"
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, name, specialization FROM doctor LIMIT 5;"
echo ""

echo "📅 Doctor Schedules:"
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, name, day, time, specialization FROM doctor_schedule LIMIT 5;"
echo ""

echo "📰 News:"
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, title, created_at FROM news LIMIT 5;"
echo ""

echo "🔧 Services:"
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, name, description FROM services LIMIT 5;"
echo ""

echo "👤 Users:"
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, username, role FROM users;"
echo ""

echo "========================================"
echo "    ✅ DATABASE INITIALIZED SUCCESSFULLY!"
echo "========================================"
echo ""
echo "🌐 Application URL: http://localhost:8080"
echo "👤 Admin Login: admin / (password from encrypted value)"
echo ""
echo "📊 Sample data has been loaded:"
echo "   - Doctors and schedules"
echo "   - News articles"
echo "   - Services"
echo "   - Admin user"
echo ""

read -p "Press Enter to continue..."
