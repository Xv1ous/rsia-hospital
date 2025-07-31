#!/bin/bash

# Hospital Application Restart Script
# This script restarts the hospital application containers

echo "🏥 Hospital Application Restart"
echo "==============================="

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose file exists
if [ ! -f "docker/docker-compose.dev.yml" ]; then
    echo "❌ docker-compose.dev.yml not found. Please run this script from the project root."
    exit 1
fi

echo ""
echo "🔄 Restarting application containers..."

# Restart containers
docker-compose -f docker/docker-compose.dev.yml restart

echo ""
print_status "Application restarted successfully!"

# Wait a moment for containers to fully start
echo "⏳ Waiting for containers to be ready..."
sleep 10

# Check container status
echo ""
echo "📊 Container Status:"
docker-compose -f docker/docker-compose.dev.yml ps

echo ""
echo "🌐 Application URL: http://localhost:8080"
echo "👤 Admin Login: admin / admin123"
echo "🗄️ MySQL Access: localhost:3307 (user: hospital_user, password: hospital_pass)"

echo ""
echo "💡 Use './scripts/simple/mysql-access.sh' for database management"
echo "💡 Use './scripts/simple/backup-db.sh' to create backups"
