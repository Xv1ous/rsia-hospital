#!/bin/bash

# Development Script untuk RSIA Buah Hati Pamulang
# Usage: ./scripts/dev.sh [start|stop|restart|build|clean]

set -e

PROJECT_NAME="RSIA Buah Hati Pamulang"
APP_PORT=8080
DB_PORT=3306

# Colors untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  $PROJECT_NAME${NC}"
    echo -e "${BLUE}  Development Environment${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_dependencies() {
    print_header
    echo "Checking dependencies..."

    # Check Java
    if command -v java &>/dev/null; then
        JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
        print_success "Java $JAVA_VERSION found"
    else
        print_error "Java not found. Please install Java 24 or higher"
        exit 1
    fi

    # Check Maven
    if command -v mvn &>/dev/null; then
        MVN_VERSION=$(mvn -version | head -n 1 | cut -d' ' -f3)
        print_success "Maven $MVN_VERSION found"
    else
        print_error "Maven not found. Please install Maven 3.6+"
        exit 1
    fi

    # Check Node.js
    if command -v node &>/dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js $NODE_VERSION found"
    else
        print_warning "Node.js not found. Tailwind CSS build will be skipped"
    fi

    # Check MySQL
    if command -v mysql &>/dev/null; then
        print_success "MySQL found"
    else
        print_warning "MySQL not found. Please ensure database is running"
    fi
}

build_frontend() {
    echo "Building frontend assets..."
    if [ -d "src/main/frontend" ]; then
        cd src/main/frontend
        if [ -f "package.json" ]; then
            npm install
            npm run build
            print_success "Frontend assets built successfully"
        fi
        cd ../../..
    fi
}

build_backend() {
    echo "Building backend application..."
    mvn clean compile
    print_success "Backend built successfully"
}

start_application() {
    echo "Starting application..."

    # Check if port is available
    if lsof -Pi :$APP_PORT -sTCP:LISTEN -t >/dev/null; then
        print_warning "Port $APP_PORT is already in use"
        read -p "Do you want to kill the process? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            lsof -ti:$APP_PORT | xargs kill -9
            print_success "Process killed"
        else
            print_error "Cannot start application. Port $APP_PORT is busy"
            exit 1
        fi
    fi

    # Start application
    mvn spring-boot:run &
    APP_PID=$!
    echo $APP_PID >.app.pid

    # Wait for application to start
    echo "Waiting for application to start..."
    for i in {1..30}; do
        if curl -s http://localhost:$APP_PORT >/dev/null; then
            print_success "Application started successfully!"
            echo -e "${GREEN}🌐 Application URL: http://localhost:$APP_PORT${NC}"
            break
        fi
        sleep 1
    done

    if [ $i -eq 30 ]; then
        print_error "Application failed to start within 30 seconds"
        exit 1
    fi
}

stop_application() {
    echo "Stopping application..."
    if [ -f .app.pid ]; then
        PID=$(cat .app.pid)
        if kill -0 $PID 2>/dev/null; then
            kill $PID
            print_success "Application stopped"
        else
            print_warning "Application was not running"
        fi
        rm .app.pid
    else
        print_warning "No PID file found"
    fi
}

clean_project() {
    echo "Cleaning project..."
    mvn clean
    rm -rf target/
    rm -f .app.pid
    print_success "Project cleaned"
}

# Main script logic
case "${1:-start}" in
"start")
    check_dependencies
    build_frontend
    build_backend
    start_application
    ;;
"stop")
    stop_application
    ;;
"restart")
    stop_application
    sleep 2
    check_dependencies
    build_frontend
    build_backend
    start_application
    ;;
"build")
    check_dependencies
    build_frontend
    build_backend
    ;;
"clean")
    clean_project
    ;;
"status")
    if [ -f .app.pid ]; then
        PID=$(cat .app.pid)
        if kill -0 $PID 2>/dev/null; then
            print_success "Application is running (PID: $PID)"
        else
            print_warning "Application is not running"
        fi
    else
        print_warning "Application is not running"
    fi
    ;;
*)
    echo "Usage: $0 {start|stop|restart|build|clean|status}"
    echo "  start   - Start the application"
    echo "  stop    - Stop the application"
    echo "  restart - Restart the application"
    echo "  build   - Build the application"
    echo "  clean   - Clean the project"
    echo "  status  - Check application status"
    exit 1
    ;;
esac
