# RSIA Hospital Makefile
# Usage: make [target]

.PHONY: help dev prod test clean jar run install frontend-build

# Default target
help:
	@echo "RSIA Hospital - Available Commands:"
	@echo ""
	@echo "Development:"
	@echo "  make dev          - Build for development"
	@echo "  make run          - Run development server"
	@echo "  make install      - Install all dependencies"
	@echo ""
	@echo "Production:"
	@echo "  make prod         - Build for production"
	@echo "  make jar          - Create production JAR"
	@echo ""
	@echo "Testing:"
	@echo "  make test         - Run all tests"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean        - Clean all build artifacts"
	@echo "  make frontend-build - Build frontend only"
	@echo ""

# Development
dev:
	@echo "🚀 Building for development..."
	./scripts/build.sh dev

run:
	@echo "🏃 Running development server..."
	mvn spring-boot:run -Pdev

install:
	@echo "📦 Installing dependencies..."
	cd src/main/frontend && npm install
	@echo "✅ Dependencies installed"

# Production
prod:
	@echo "🏭 Building for production..."
	./scripts/build.sh prod

jar:
	@echo "📦 Creating production JAR..."
	./scripts/build.sh jar

# Testing
test:
	@echo "🧪 Running tests..."
	./scripts/build.sh test

# Maintenance
clean:
	@echo "🧹 Cleaning build artifacts..."
	./scripts/build.sh clean

frontend-build:
	@echo "🎨 Building frontend..."
	cd src/main/frontend && npm run build:prod

# Quick commands
quick-dev:
	@echo "⚡ Quick development build..."
	mvn compile -Pdev -q

quick-prod:
	@echo "⚡ Quick production build..."
	mvn compile -Pprod -q

# Docker commands (if needed in future)
docker-build:
	@echo "🐳 Building Docker image..."
	docker build -t rsia-hospital .

docker-run:
	@echo "🐳 Running Docker container..."
	docker run -p 8080:8080 rsia-hospital

# Database commands
db-migrate:
	@echo "🗄️ Running database migrations..."
	mvn flyway:migrate

db-clean:
	@echo "🗄️ Cleaning database..."
	mvn flyway:clean

# Monitoring
health-check:
	@echo "🏥 Checking application health..."
	curl -f http://localhost:8080/actuator/health || echo "❌ Application not running"

# Performance testing
perf-test:
	@echo "⚡ Running performance tests..."
	cd src/main/frontend && npm run build:full

# Security check
security-check:
	@echo "🔒 Running security checks..."
	mvn dependency:check

# Documentation
docs:
	@echo "📚 Generating documentation..."
	mvn javadoc:javadoc

# Backup
backup:
	@echo "💾 Creating backup..."
	tar -czf backup-$(shell date +%Y%m%d-%H%M%S).tar.gz \
		--exclude=target \
		--exclude=node_modules \
		--exclude=.git \
		.

# Development shortcuts
watch:
	@echo "👀 Starting watch mode..."
	cd src/main/frontend && npm run watch

lint:
	@echo "🔍 Running linter..."
	cd src/main/frontend && npm run lint

format:
	@echo "✨ Formatting code..."
	mvn spring-javaformat:apply
