#!/bin/bash

# Build and Deploy Script untuk RSIA Buah Hati Pamulang
# Usage: ./scripts/build-and-deploy.sh [dev|prod]

set -e

# Colors untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function untuk print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function untuk check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    # Check Java
    if ! command -v java &> /dev/null; then
        print_error "Java tidak ditemukan. Silakan install Java 21 terlebih dahulu."
        exit 1
    fi

    # Check Maven
    if ! command -v mvn &> /dev/null; then
        print_error "Maven tidak ditemukan. Silakan install Maven terlebih dahulu."
        exit 1
    fi

    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker tidak ditemukan. Silakan install Docker terlebih dahulu."
        exit 1
    fi

    print_success "Prerequisites check passed"
}

# Function untuk build application
build_application() {
    print_status "Building application with Maven..."

    # Skip frontend build untuk menghindari npm dependency
    mvn clean package -DskipTests -Dmaven.paseq.skip=true

    if [ $? -eq 0 ]; then
        print_success "Application built successfully"
    else
        print_error "Build failed"
        exit 1
    fi
}

# Function untuk build Docker image
build_docker_image() {
    print_status "Building Docker image..."

    # Use simple Dockerfile
    docker build -f ../docker/Dockerfile.simple -t hospital-app:latest .

    if [ $? -eq 0 ]; then
        print_success "Docker image built successfully"
    else
        print_error "Docker build failed"
        exit 1
    fi
}

# Function untuk start development environment
start_dev() {
    print_status "Starting development environment..."
    docker-compose -f ../docker/docker-compose.dev.yml up -d
    print_success "Development environment started"
    print_status "Aplikasi tersedia di: http://localhost:8080"
    print_status "Database tersedia di: localhost:3306"
}

# Function untuk start production environment
start_prod() {
    print_status "Starting production environment..."
    docker-compose -f ../docker/docker-compose.yml up -d
    print_success "Production environment started"
    print_status "Aplikasi tersedia di: http://localhost:8080"
}

# Function untuk show logs
show_logs() {
    print_status "Showing application logs..."
    if [ "$1" = "prod" ]; then
        docker-compose logs -f hospital-app
    else
        docker-compose -f docker-compose.dev.yml logs -f hospital-app
    fi
}

# Main script logic
case "${1:-dev}" in
    "dev")
        check_prerequisites
        build_application
        build_docker_image
        start_dev
        print_status "Waiting for application to start..."
        sleep 10
        show_logs "dev"
        ;;
    "prod")
        check_prerequisites
        build_application
        build_docker_image
        start_prod
        print_status "Waiting for application to start..."
        sleep 10
        show_logs "prod"
        ;;
    "build")
        check_prerequisites
        build_application
        build_docker_image
        print_success "Build completed successfully"
        ;;
    "logs")
        show_logs "${2:-dev}"
        ;;
    *)
        echo "Usage: $0 [dev|prod|build|logs]"
        echo ""
        echo "Commands:"
        echo "  dev     - Build and start development environment"
        echo "  prod    - Build and start production environment"
        echo "  build   - Build application and Docker image only"
        echo "  logs    - Show application logs (dev|prod)"
        exit 1
        ;;
esac
