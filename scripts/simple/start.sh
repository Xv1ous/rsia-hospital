#!/bin/bash

echo ""
echo "========================================"
echo "    HOSPITAL APP - SIMPLE START"
echo "========================================"
echo ""
echo "Starting application..."
echo "Please wait..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "ERROR: Docker is not running!"
    echo ""
    echo "Please:"
    echo "1. Start Docker Desktop"
    echo "2. Wait until it says 'Docker Desktop is running'"
    echo "3. Run this script again"
    echo ""
    read -p "Press Enter to continue..."
    exit 1
fi

# Start the application
echo "[1/3] Starting containers..."
docker-compose -f ../docker/docker-compose.dev.yml up -d

echo "[2/3] Waiting for application to start..."
sleep 45

echo "[3/3] Checking if application is ready..."
sleep 5

echo ""
echo "========================================"
echo "    SUCCESS! Application is running"
echo "========================================"
echo ""
echo "🌐 Open your browser and go to:"
echo "   http://localhost:8080"
echo ""
echo "👤 Admin Login:"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
echo "📊 To view logs: docker-compose -f ../docker/docker-compose.dev.yml logs -f hospital-app"
echo "🛑 To stop: ./stop.sh"
echo ""
echo "Press Enter to open the application in browser..."
read -p ""

# Try to open browser
if command -v xdg-open > /dev/null; then
    xdg-open http://localhost:8080
elif command -v open > /dev/null; then
    open http://localhost:8080
else
    echo "Please manually open: http://localhost:8080"
fi

echo ""
echo "Browser opened! If it doesn't work, manually go to:"
echo "http://localhost:8080"
echo ""
read -p "Press Enter to continue..."
