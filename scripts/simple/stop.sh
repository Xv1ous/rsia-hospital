#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo ""
echo "========================================"
echo "    HOSPITAL APP - SIMPLE STOP"
echo "========================================"
echo ""
echo "Stopping application..."
echo ""

docker-compose -f "$PROJECT_ROOT/docker/docker-compose.dev.yml" down

echo ""
echo "========================================"
echo "    Application stopped successfully!"
echo "========================================"
echo ""
echo "To start again, run: ./start.sh"
echo ""
read -p "Press Enter to continue..."
