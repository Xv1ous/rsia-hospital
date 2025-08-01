#!/bin/bash

echo ""
echo "========================================"
echo "    HOSPITAL APP - QUICK ACCESS"
echo "========================================"
echo ""
echo "Choose an option:"
echo ""
echo "[1] Build Project (Create JAR file)"
echo "[2] Start Application"
echo "[3] Stop Application"
echo "[4] Restart Application"
echo "[5] View Application Status"
echo "[6] View Application Logs"
echo "[7] MySQL Database Access"
echo "[8] Initialize Database (Reset & Load Sample Data)"
echo "[9] Open Documentation"
echo "[10] Open Simple Guide"
echo "[11] Exit"
echo ""
read -p "Enter your choice (1-11): " choice

case $choice in
    1)
        echo ""
        echo "Building project..."
        ./scripts/simple/build.sh
        ;;
    2)
        echo ""
        echo "Starting application..."
        ./scripts/simple/start.sh
        ;;
    3)
        echo ""
        echo "Stopping application..."
        ./scripts/simple/stop.sh
        ;;
    4)
        echo ""
        echo "Restarting application..."
        ./scripts/simple/restart.sh
        ;;
    5)
        echo ""
        echo "Checking application status..."
        docker-compose -f docker/docker-compose.dev.yml ps
        echo ""
        read -p "Press Enter to continue..."
        ;;
    6)
        echo ""
        echo "Opening application logs..."
        docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app
        ;;
    7)
        echo ""
        echo "Opening MySQL Database Access..."
        ./scripts/simple/mysql-access.sh
        ;;
    8)
        echo ""
        echo "Initializing database..."
        ./scripts/simple/initialize-db.sh
        ;;
    9)
        echo ""
        echo "Opening documentation..."
        if command -v xdg-open > /dev/null; then
            xdg-open docs/
        elif command -v open > /dev/null; then
            open docs/
        else
            echo "Please manually open the docs/ folder"
        fi
        ;;
    10)
        echo ""
        echo "Opening simple guide..."
        if command -v xdg-open > /dev/null; then
            xdg-open docs/README_SIMPLE.md
        elif command -v open > /dev/null; then
            open docs/README_SIMPLE.md
        else
            echo "Please manually open docs/README_SIMPLE.md"
        fi
        ;;
    11)
        echo ""
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo ""
        echo "Invalid choice. Please try again."
        read -p "Press Enter to continue..."
        ./quick-access.sh
        ;;
esac
