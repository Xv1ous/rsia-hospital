#!/bin/bash

# Hospital App Build Script
# This script builds the project using Maven

echo ""
echo "========================================"
echo "    HOSPITAL APP - BUILD PROJECT"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Change to project root
cd "$PROJECT_ROOT"

echo "Building project from: $PROJECT_ROOT"
echo ""

# Check if Maven wrapper exists
if [ ! -f "./mvnw" ]; then
    print_error "Maven wrapper (mvnw) not found!"
    echo "Please ensure you're running this script from the project root directory."
    exit 1
fi

# Check if Maven wrapper is executable
if [ ! -x "./mvnw" ]; then
    print_warning "Making Maven wrapper executable..."
    chmod +x ./mvnw
fi

echo "[1/4] Cleaning previous build..."
./mvnw clean

if [ $? -ne 0 ]; then
    print_error "Clean failed!"
    exit 1
fi
print_success "Clean completed"

echo ""
echo "[2/4] Installing dependencies..."
./mvnw dependency:resolve

if [ $? -ne 0 ]; then
    print_error "Dependency resolution failed!"
    exit 1
fi
print_success "Dependencies resolved"

echo ""
echo "[3/4] Building frontend assets..."
./mvnw compile -DskipTests

if [ $? -ne 0 ]; then
    print_error "Frontend build failed!"
    exit 1
fi
print_success "Frontend assets built"

echo ""
echo "[4/4] Creating JAR file..."
./mvnw package -DskipTests

if [ $? -ne 0 ]; then
    print_error "JAR creation failed!"
    exit 1
fi
print_success "JAR file created"

echo ""
echo "========================================"
echo "    BUILD COMPLETED SUCCESSFULLY!"
echo "========================================"
echo ""

# Check if JAR file was created
if [ -f "target/hospital-0.0.1-SNAPSHOT.jar" ]; then
    JAR_SIZE=$(du -h target/hospital-0.0.1-SNAPSHOT.jar | cut -f1)
    print_success "JAR file created: target/hospital-0.0.1-SNAPSHOT.jar ($JAR_SIZE)"
else
    print_error "JAR file not found in target directory!"
    exit 1
fi

echo ""
echo "🎉 Project built successfully!"
echo ""
echo "Next steps:"
echo "  🚀 Start application: ./scripts/simple/start.sh"
echo "  🗄️  Initialize database: ./scripts/simple/initialize-db.sh"
echo "  🛑 Stop application: ./scripts/simple/stop.sh"
echo ""
echo "Application will be available at: http://localhost:8080"
echo "Admin login: admin / admin123"
echo ""

read -p "Press Enter to continue..."
