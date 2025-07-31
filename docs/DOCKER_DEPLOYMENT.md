# Docker Deployment Guide

## Overview

Docker configuration untuk aplikasi RSIA Buah Hati Pamulang dengan multi-stage build, MySQL database, dan Nginx reverse proxy.

## Prerequisites

### Software Requirements

- Docker Engine 20.10+
- Docker Compose 2.0+
- Git

### System Requirements

- Minimum 4GB RAM
- 10GB free disk space
- Port 8080, 3306 (dan 80, 443 untuk production) available

## Quick Start

### 1. Development Environment

```bash
# Start development environment
./scripts/docker-deploy.sh dev

# Atau manual
docker-compose -f docker-compose.dev.yml up -d
```

### 2. Production Environment

```bash
# Start production environment (dengan Nginx)
./scripts/docker-deploy.sh prod

# Atau manual
docker-compose up -d
```

### 3. Stop Environment

```bash
# Stop semua containers
./scripts/docker-deploy.sh stop

# Atau manual
docker-compose down
```

## File Structure

```
hospital/
├── Dockerfile                    # Multi-stage Docker build
├── docker-compose.yml           # Production environment
├── docker-compose.dev.yml       # Development environment
├── .dockerignore                # Exclude files from build
├── scripts/
│   └── docker-deploy.sh         # Deployment script
└── DOCKER_DEPLOYMENT.md         # This file
```

## Configuration

### Environment Variables

#### Database Configuration

```yaml
SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/hospital?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
SPRING_DATASOURCE_USERNAME: hospital_user
SPRING_DATASOURCE_PASSWORD: hospital_pass
```

#### Application Configuration

```yaml
SPRING_APPLICATION_NAME: rsia-buah-hati-pamulang
SERVER_PORT: 8080
SPRING_JPA_HIBERNATE_DDL_AUTO: update
```

#### Security Configuration

```yaml
SPRING_SECURITY_USER_NAME: admin
SPRING_SECURITY_USER_PASSWORD: admin123
```

### JVM Options

```bash
JAVA_OPTS: "-Xms512m -Xmx1024m -XX:+UseG1GC -XX:+UseContainerSupport"
```

## Services

### 1. MySQL Database

- **Image:** mysql:8.0
- **Port:** 3306
- **Database:** hospital
- **User:** hospital_user
- **Password:** hospital_pass
- **Root Password:** rootpassword

### 2. Spring Boot Application

- **Port:** 8080
- **Health Check:** http://localhost:8080/
- **Logs:** /app/logs

### 3. Nginx (Production Only)

- **Port:** 80 (HTTP), 443 (HTTPS)
- **Profile:** production

## Deployment Scripts

### Available Commands

```bash
./scripts/docker-deploy.sh dev      # Start development
./scripts/docker-deploy.sh prod     # Start production
./scripts/docker-deploy.sh stop     # Stop containers
./scripts/docker-deploy.sh clean    # Clean up resources
./scripts/docker-deploy.sh logs     # Show logs
./scripts/docker-deploy.sh status   # Show status
./scripts/docker-deploy.sh restart  # Restart development
```

### Manual Commands

#### Build Image

```bash
docker build -t hospital-app:latest .
```

#### Run Development

```bash
docker-compose -f docker-compose.dev.yml up -d
```

#### Run Production

```bash
docker-compose up -d
```

#### View Logs

```bash
# Application logs
docker-compose logs -f hospital-app

# Database logs
docker-compose logs -f mysql

# All logs
docker-compose logs -f
```

#### Access Database

```bash
# Connect to MySQL
docker exec -it hospital-mysql mysql -u hospital_user -p hospital

# Backup database
docker exec hospital-mysql mysqldump -u hospital_user -p hospital > backup.sql

# Restore database
docker exec -i hospital-mysql mysql -u hospital_user -p hospital < backup.sql
```

## Health Checks

### Application Health Check

```bash
curl -f http://localhost:8080/ || exit 1
```

### Database Health Check

```bash
docker exec hospital-mysql mysqladmin ping -h localhost
```

## Monitoring

### Container Status

```bash
docker-compose ps
```

### Resource Usage

```bash
docker stats
```

### Log Monitoring

```bash
# Follow logs in real-time
docker-compose logs -f

# View specific service logs
docker-compose logs -f hospital-app
```

## Troubleshooting

### Common Issues

#### 1. Port Already in Use

```bash
# Check what's using the port
sudo lsof -i :8080

# Kill process
sudo kill -9 <PID>
```

#### 2. Database Connection Issues

```bash
# Check database status
docker-compose logs mysql

# Restart database
docker-compose restart mysql
```

#### 3. Application Won't Start

```bash
# Check application logs
docker-compose logs hospital-app

# Check if database is ready
docker-compose logs mysql | grep "ready for connections"
```

#### 4. Memory Issues

```bash
# Check memory usage
docker stats

# Increase memory limit in docker-compose.yml
environment:
  JAVA_OPTS: "-Xms1g -Xmx2g -XX:+UseG1GC"
```

### Clean Up

```bash
# Remove all containers and volumes
./scripts/docker-deploy.sh clean

# Or manual
docker-compose down -v --remove-orphans
docker system prune -f
```

## Security Considerations

### 1. Change Default Passwords

```yaml
# In docker-compose.yml
environment:
  MYSQL_ROOT_PASSWORD: your_secure_password
  MYSQL_PASSWORD: your_secure_password
  SPRING_SECURITY_USER_PASSWORD: your_secure_password
```

### 2. Use Environment Files

```bash
# Create .env file
MYSQL_ROOT_PASSWORD=your_secure_password
MYSQL_PASSWORD=your_secure_password
SPRING_SECURITY_USER_PASSWORD=your_secure_password
```

### 3. Network Security

```yaml
# Use custom networks
networks:
  hospital-network:
    driver: bridge
    internal: true # For internal communication only
```

## Performance Optimization

### 1. JVM Tuning

```bash
# Production settings
JAVA_OPTS: "-Xms1g -Xmx2g -XX:+UseG1GC -XX:+UseContainerSupport -XX:MaxGCPauseMillis=200"
```

### 2. Database Optimization

```yaml
# MySQL configuration
command: --innodb-buffer-pool-size=1G --max-connections=200
```

### 3. Nginx Configuration

```nginx
# Enable gzip compression
gzip on;
gzip_types text/plain text/css application/json application/javascript;
```

## Backup and Recovery

### Database Backup

```bash
# Create backup
docker exec hospital-mysql mysqldump -u hospital_user -p hospital > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore backup
docker exec -i hospital-mysql mysql -u hospital_user -p hospital < backup.sql
```

### Volume Backup

```bash
# Backup volumes
docker run --rm -v hospital_mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql_backup.tar.gz -C /data .

# Restore volumes
docker run --rm -v hospital_mysql_data:/data -v $(pwd):/backup alpine tar xzf /backup/mysql_backup.tar.gz -C /data
```

## Scaling

### Horizontal Scaling

```yaml
# Scale application instances
docker-compose up -d --scale hospital-app=3
```

### Load Balancing

```nginx
# Nginx upstream configuration
upstream hospital_app {
    server hospital-app:8080;
    server hospital-app:8081;
    server hospital-app:8082;
}
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Deploy to Production
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy with Docker
        run: |
          docker-compose pull
          docker-compose up -d
```

## Support

Untuk bantuan lebih lanjut:

1. Check logs: `./scripts/docker-deploy.sh logs`
2. Check status: `./scripts/docker-deploy.sh status`
3. Restart services: `./scripts/docker-deploy.sh restart`
