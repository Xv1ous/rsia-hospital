#!/bin/bash

echo ""
echo "========================================"
echo "    HOSPITAL APP - QUICK ACCESS"
echo "========================================"
echo ""
echo "Choose an option:"
echo ""
echo "[1] Start Application"
echo "[2] Stop Application"
echo "[3] Restart Application"
echo "[4] View Application Status"
echo "[5] View Application Logs"
echo "[6] MySQL Database Access"
echo "[7] Initialize Database (Reset & Load Sample Data)"
echo "[8] Open Documentation"
echo "[9] Open Simple Guide"
echo "[10] Exit"
echo ""
read -p "Enter your choice (1-10): " choice

case $choice in
    1)
        echo ""
        echo "Starting application..."
        ./scripts/simple/start.sh
        ;;
    2)
        echo ""
        echo "Stopping application..."
        ./scripts/simple/stop.sh
        ;;
    3)
        echo ""
        echo "Restarting application..."
        ./scripts/simple/restart.sh
        ;;
    4)
        echo ""
        echo "Checking application status..."
        docker-compose -f docker/docker-compose.dev.yml ps
        echo ""
        read -p "Press Enter to continue..."
        ;;
    5)
        echo ""
        echo "Opening application logs..."
        docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app
        ;;
    6)
        echo ""
        echo "Opening MySQL Database Access..."
        ./scripts/simple/mysql-access.sh
        ;;
    7)
        echo ""
        echo "Initializing database..."
        ./scripts/simple/initialize-db.sh
        ;;
    8)
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
    9)
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
    10)
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
