#!/bin/bash

echo ""
echo "========================================"
echo "    HOSPITAL APP - SIMPLE STOP"
echo "========================================"
echo ""
echo "Stopping application..."
echo ""

docker-compose -f ../docker/docker-compose.dev.yml down

echo ""
echo "========================================"
echo "    Application stopped successfully!"
echo "========================================"
echo ""
echo "To start again, run: ./start.sh"
echo ""
read -p "Press Enter to continue..."
