# Makefile untuk RSIA Buah Hati Pamulang
# Usage: make [target]

.PHONY: help install build run clean test docker-build docker-run dev

# Variables
APP_NAME = hospital
JAR_FILE = target/$(APP_NAME)-0.0.1-SNAPSHOT.jar
DOCKER_IMAGE = rsia-buah-hati-pamulang

# Default target
help:
	@echo "RSIA Buah Hati Pamulang - Development Commands"
	@echo "=============================================="
	@echo "install     - Install all dependencies"
	@echo "build       - Build the application"
	@echo "run         - Run the application"
	@echo "dev         - Start development environment"
	@echo "clean       - Clean build artifacts"
	@echo "test        - Run tests"
	@echo "docker-build- Build Docker image"
	@echo "docker-run  - Run with Docker Compose"
	@echo "stop        - Stop the application"

# Install dependencies
install:
	@echo "Installing dependencies..."
	mvn dependency:resolve
	cd src/main/frontend && npm install
	@echo "✅ Dependencies installed"

# Build application
build:
	@echo "Building application..."
	mvn clean compile
	cd src/main/frontend && npm run build
	@echo "✅ Application built"

# Run application
run:
	@echo "Starting application..."
	mvn spring-boot:run

# Development environment
dev:
	@echo "Starting development environment..."
	./scripts/dev.sh start

# Stop application
stop:
	@echo "Stopping application..."
	./scripts/dev.sh stop

# Clean project
clean:
	@echo "Cleaning project..."
	mvn clean
	rm -rf target/
	rm -f .app.pid
	@echo "✅ Project cleaned"

# Run tests
test:
	@echo "Running tests..."
	mvn test
	@echo "✅ Tests completed"

# Build Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t $(DOCKER_IMAGE) .
	@echo "✅ Docker image built"

# Run with Docker Compose
docker-run:
	@echo "Starting with Docker Compose..."
	docker-compose up -d
	@echo "✅ Application started with Docker"

# Stop Docker containers
docker-stop:
	@echo "Stopping Docker containers..."
	docker-compose down
	@echo "✅ Docker containers stopped"

# Database operations
db-create:
	@echo "Creating database..."
	mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS hospital;"
	@echo "✅ Database created"

db-reset:
	@echo "Resetting database..."
	mysql -u root -p -e "DROP DATABASE IF EXISTS hospital; CREATE DATABASE hospital;"
	@echo "✅ Database reset"

# Frontend operations
frontend-watch:
	@echo "Starting frontend watch mode..."
	cd src/main/frontend && npm run watch

# Production build
prod-build:
	@echo "Building for production..."
	mvn clean package -DskipTests
	@echo "✅ Production build completed"

# Check application status
status:
	@echo "Checking application status..."
	./scripts/dev.sh status

# Quick start (install + build + run)
quick-start: install build run
