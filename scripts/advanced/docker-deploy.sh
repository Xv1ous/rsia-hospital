#!/bin/bash

# Docker Deployment Script untuk RSIA Buah Hati Pamulang
# Usage: ./scripts/docker-deploy.sh [dev|prod|stop|clean]

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

# Function untuk check Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker tidak ditemukan. Silakan install Docker terlebih dahulu."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose tidak ditemukan. Silakan install Docker Compose terlebih dahulu."
        exit 1
    fi

    print_success "Docker dan Docker Compose tersedia"
}

# Function untuk build image
build_image() {
    print_status "Building Docker image..."
    docker build -t hospital-app:latest .
    print_success "Docker image berhasil di-build"
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
    print_status "Nginx tersedia di: http://localhost:80"
}

# Function untuk stop containers
stop_containers() {
    print_status "Stopping containers..."
    docker-compose down
    docker-compose -f docker-compose.dev.yml down
    print_success "Containers stopped"
}

# Function untuk clean up
clean_up() {
    print_warning "Cleaning up Docker resources..."
    docker-compose down -v --remove-orphans
    docker-compose -f docker-compose.dev.yml down -v --remove-orphans
    docker system prune -f
    print_success "Cleanup completed"
}

# Function untuk show logs
show_logs() {
    print_status "Showing application logs..."
    docker-compose logs -f hospital-app
}

# Function untuk show status
show_status() {
    print_status "Container status:"
    docker-compose ps
    echo ""
    print_status "Resource usage:"
    docker stats --no-stream
}

# Main script logic
case "${1:-dev}" in
    "dev")
        check_docker
        build_image
        start_dev
        ;;
    "prod")
        check_docker
        build_image
        start_prod
        ;;
    "stop")
        stop_containers
        ;;
    "clean")
        clean_up
        ;;
    "logs")
        show_logs
        ;;
    "status")
        show_status
        ;;
    "restart")
        stop_containers
        sleep 2
        check_docker
        build_image
        start_dev
        ;;
    *)
        echo "Usage: $0 [dev|prod|stop|clean|logs|status|restart]"
        echo ""
        echo "Commands:"
        echo "  dev     - Start development environment"
        echo "  prod    - Start production environment (with nginx)"
        echo "  stop    - Stop all containers"
        echo "  clean   - Clean up Docker resources"
        echo "  logs    - Show application logs"
        echo "  status  - Show container status"
        echo "  restart - Restart development environment"
        exit 1
        ;;
esac
