#!/bin/bash

# RSIA Hospital Build Script
# Usage: ./scripts/build.sh [dev|prod|clean|test]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    if ! command_exists java; then
        print_error "Java is not installed or not in PATH"
        exit 1
    fi

    if ! command_exists mvn; then
        print_error "Maven is not installed or not in PATH"
        exit 1
    fi

    if ! command_exists node; then
        print_error "Node.js is not installed or not in PATH"
        exit 1
    fi

    if ! command_exists npm; then
        print_error "npm is not installed or not in PATH"
        exit 1
    fi

    print_success "All prerequisites are satisfied"
}

# Function to build frontend
build_frontend() {
    local profile=$1
    print_status "Building frontend for $profile profile..."

    cd src/main/frontend

    # Install dependencies
    print_status "Installing npm dependencies..."
    npm ci --silent

    # Build based on profile
    if [ "$profile" = "prod" ]; then
        print_status "Building optimized production CSS..."
        npm run build:prod
    else
        print_status "Building development CSS..."
        npm run build
    fi

    cd ../../..
    print_success "Frontend build completed"
}

# Function to build backend
build_backend() {
    local profile=$1
    print_status "Building backend for $profile profile..."

    # Clean previous build
    print_status "Cleaning previous build..."
    mvn clean -q

    # Build with profile
    print_status "Building with Maven..."
    mvn compile -P$profile -q

    print_success "Backend build completed"
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    mvn test -q
    print_success "Tests completed"
}

# Function to create JAR
create_jar() {
    local profile=$1
    print_status "Creating JAR for $profile profile..."

    mvn package -P$profile -DskipTests -q

    print_success "JAR created: target/rsia-hospital.jar"
}

# Function to clean everything
clean_all() {
    print_status "Cleaning all build artifacts..."

    # Clean Maven
    mvn clean -q

    # Clean npm
    cd src/main/frontend
    rm -rf node_modules package-lock.json
    cd ../../..

    # Clean target
    rm -rf target/

    print_success "Clean completed"
}

# Function to show help
show_help() {
    echo "RSIA Hospital Build Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  dev     Build for development (default)"
    echo "  prod    Build for production (optimized)"
    echo "  test    Run tests"
    echo "  clean   Clean all build artifacts"
    echo "  jar     Create JAR file for production"
    echo "  help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 dev      # Build for development"
    echo "  $0 prod     # Build for production"
    echo "  $0 jar      # Create production JAR"
    echo "  $0 clean    # Clean everything"
}

# Main script logic
main() {
    local command=${1:-dev}

    case $command in
        "dev")
            check_prerequisites
            build_frontend "dev"
            build_backend "dev"
            print_success "Development build completed successfully!"
            ;;
        "prod")
            check_prerequisites
            build_frontend "prod"
            build_backend "prod"
            print_success "Production build completed successfully!"
            ;;
        "test")
            check_prerequisites
            run_tests
            ;;
        "jar")
            check_prerequisites
            build_frontend "prod"
            create_jar "prod"
            ;;
        "clean")
            clean_all
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
