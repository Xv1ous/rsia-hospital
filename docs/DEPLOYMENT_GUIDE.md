# RSIA Buah Hati Pamulang - Deployment Guide

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Database Setup](#database-setup)
4. [Application Deployment](#application-deployment)
5. [Docker Deployment](#docker-deployment)
6. [Production Configuration](#production-configuration)
7. [SSL/HTTPS Setup](#sslhttps-setup)
8. [Monitoring & Logging](#monitoring--logging)
9. [Backup & Recovery](#backup--recovery)
10. [Troubleshooting](#troubleshooting)

---

## 🔧 Prerequisites

### System Requirements

#### Minimum Requirements

- **CPU**: 2 cores
- **RAM**: 4GB
- **Storage**: 20GB SSD
- **OS**: Ubuntu 20.04+ / CentOS 8+ / Debian 11+

#### Recommended Requirements

- **CPU**: 4+ cores
- **RAM**: 8GB+
- **Storage**: 50GB+ SSD
- **OS**: Ubuntu 22.04 LTS

### Software Requirements

#### Required Software

```bash
# Java 21
sudo apt update
sudo apt install openjdk-21-jdk

# Maven 3.6+
sudo apt install maven

# MySQL 8.0+
sudo apt install mysql-server

# Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs

# Nginx
sudo apt install nginx

# Git
sudo apt install git
```

#### Optional Software

```bash
# Docker & Docker Compose
sudo apt install docker.io docker-compose

# Certbot (for SSL)
sudo apt install certbot python3-certbot-nginx

# Monitoring tools
sudo apt install htop iotop nethogs
```

---

## 🌍 Environment Setup

### 1. Create Application User

```bash
# Create system user
sudo useradd -r -s /bin/false hospital
sudo mkdir -p /opt/hospital
sudo chown hospital:hospital /opt/hospital
```

### 2. Clone Repository

```bash
# Clone to production directory
sudo -u hospital git clone https://github.com/your-repo/hospital.git /opt/hospital/app
cd /opt/hospital/app

# Set proper permissions
sudo chown -R hospital:hospital /opt/hospital/app
```

### 3. Environment Variables

```bash
# Create environment file
sudo -u hospital nano /opt/hospital/app/.env
```

**Environment Variables**:

```bash
# Application
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8080
APP_NAME=rsia-buah-hati-pamulang

# Database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=hospital
DB_USERNAME=hospital_user
DB_PASSWORD=secure_password_here

# Security
JWT_SECRET=your_jwt_secret_here
BCRYPT_STRENGTH=12

# Email (if needed)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password

# Monitoring
ENABLE_ACTUATOR=true
METRICS_ENABLED=true
```

---

## 🗄️ Database Setup

### 1. MySQL Installation & Configuration

```bash
# Install MySQL
sudo apt install mysql-server

# Secure MySQL installation
sudo mysql_secure_installation
```

### 2. Create Database & User

```sql
-- Connect to MySQL as root
sudo mysql -u root -p

-- Create database
CREATE DATABASE hospital CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create dedicated user
CREATE USER 'hospital_user'@'localhost' IDENTIFIED BY 'secure_password_here';

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER
ON hospital.* TO 'hospital_user'@'localhost';

-- Grant additional permissions for development
GRANT CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW,
CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON hospital.* TO 'hospital_user'@'localhost';

FLUSH PRIVILEGES;
EXIT;
```

### 3. Database Configuration

```bash
# Test database connection
mysql -u hospital_user -p hospital -e "SELECT 1;"
```

### 4. Initialize Database Schema

```bash
# Run database migration
cd /opt/hospital/app
mvn spring-boot:run -Dspring.profiles.active=prod
```

---

## 🚀 Application Deployment

### 1. Build Application

```bash
# Navigate to application directory
cd /opt/hospital/app

# Clean and build
mvn clean package -DskipTests

# Verify JAR file
ls -la target/hospital-0.0.1-SNAPSHOT.jar
```

### 2. Create Systemd Service

```bash
# Create service file
sudo nano /etc/systemd/system/hospital.service
```

**Service Configuration**:

```ini
[Unit]
Description=RSIA Buah Hati Pamulang Hospital Management System
After=network.target mysql.service
Wants=mysql.service

[Service]
Type=simple
User=hospital
Group=hospital
WorkingDirectory=/opt/hospital/app
ExecStart=/usr/bin/java -Xms512m -Xmx2g -jar target/hospital-0.0.1-SNAPSHOT.jar
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=hospital

# Environment variables
Environment=SPRING_PROFILES_ACTIVE=prod
Environment=JAVA_OPTS=-Djava.security.egd=file:/dev/./urandom

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ReadWritePaths=/opt/hospital/app/logs

[Install]
WantedBy=multi-user.target
```

### 3. Start Application Service

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service
sudo systemctl enable hospital

# Start service
sudo systemctl start hospital

# Check status
sudo systemctl status hospital

# View logs
sudo journalctl -u hospital -f
```

### 4. Application Configuration

```bash
# Create production properties
sudo -u hospital nano /opt/hospital/app/src/main/resources/application-prod.properties
```

**Production Configuration**:

```properties
# Server Configuration
server.port=8080
server.servlet.context-path=/

# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/hospital?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA Configuration
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.format_sql=false

# Thymeleaf Configuration
spring.thymeleaf.cache=true
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html

# Logging Configuration
logging.level.com.example.hospital=INFO
logging.level.org.springframework.web=WARN
logging.file.name=/opt/hospital/app/logs/hospital.log
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n

# Security Configuration
spring.security.user.name=${ADMIN_USERNAME:admin}
spring.security.user.password=${ADMIN_PASSWORD:admin123}

# Session Configuration
server.servlet.session.timeout=30m
server.servlet.session.cookie.secure=true
server.servlet.session.cookie.http-only=true

# Actuator Configuration
management.endpoints.web.exposure.include=health,info,metrics
management.endpoint.health.show-details=when-authorized
management.endpoint.health.show-components=always

# Metrics Configuration
management.metrics.export.prometheus.enabled=true
management.metrics.enable.jvm=true
management.metrics.enable.process=true
management.metrics.enable.system=true

# Error Handling
server.error.whitelabel.enabled=false
server.error.include-message=never
server.error.include-stacktrace=never

# File Upload Configuration
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

---

## 🐳 Docker Deployment

### 1. Dockerfile

```dockerfile
# Multi-stage build
FROM maven:3.9.5-openjdk-21 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Build application
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:21-jre-slim

# Create application user
RUN groupadd -r hospital && useradd -r -g hospital hospital

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create application directory
WORKDIR /app

# Copy JAR file
COPY --from=build /app/target/hospital-0.0.1-SNAPSHOT.jar app.jar

# Create logs directory
RUN mkdir -p /app/logs && chown -R hospital:hospital /app

# Switch to application user
USER hospital

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run application
ENTRYPOINT ["java", "-Xms512m", "-Xmx2g", "-jar", "app.jar"]
```

### 2. Docker Compose for Production

```yaml
# docker-compose.prod.yml
version: "3.8"

services:
  # MySQL Database
  mysql:
    image: mysql:8.0
    container_name: hospital-mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: hospital
      MYSQL_USER: hospital_user
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - hospital-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  # Spring Boot Application
  app:
    build: .
    container_name: hospital-app
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      DB_HOST: mysql
      DB_PORT: 3306
      DB_NAME: hospital
      DB_USERNAME: hospital_user
      DB_PASSWORD: ${MYSQL_PASSWORD}
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      mysql:
        condition: service_healthy
    networks:
      - hospital-network
    volumes:
      - app_logs:/app/logs
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    container_name: hospital-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
      - ./static:/var/www/static
    depends_on:
      - app
    networks:
      - hospital-network

volumes:
  mysql_data:
  app_logs:

networks:
  hospital-network:
    driver: bridge
```

### 3. Deploy with Docker

```bash
# Build and start services
docker-compose -f docker-compose.prod.yml up -d

# Check service status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f app

# Scale application (if needed)
docker-compose -f docker-compose.prod.yml up -d --scale app=3
```

---

## ⚙️ Production Configuration

### 1. Nginx Configuration

```nginx
# /etc/nginx/sites-available/hospital
upstream hospital_backend {
    server 127.0.0.1:8080;
    # Add more servers for load balancing
    # server 127.0.0.1:8081;
    # server 127.0.0.1:8082;
}

# Rate limiting
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
limit_req_zone $binary_remote_addr zone=admin:10m rate=5r/s;

server {
    listen 80;
    server_name buahhatipamulang.co.id www.buahhatipamulang.co.id;

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name buahhatipamulang.co.id www.buahhatipamulang.co.id;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/buahhatipamulang.co.id/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/buahhatipamulang.co.id/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin";

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # Static files
    location /static/ {
        alias /opt/hospital/app/src/main/resources/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
        add_header X-Content-Type-Options nosniff;
    }

    # Admin panel (rate limited)
    location /admin/ {
        limit_req zone=admin burst=10 nodelay;
        proxy_pass http://hospital_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # API endpoints (rate limited)
    location /api/ {
        limit_req zone=api burst=20 nodelay;
        proxy_pass http://hospital_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Main application
    location / {
        proxy_pass http://hospital_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Timeouts
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
```

### 2. Enable Nginx Site

```bash
# Create symlink
sudo ln -s /etc/nginx/sites-available/hospital /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### 3. Firewall Configuration

```bash
# Configure UFW firewall
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# Check status
sudo ufw status
```

---

## 🔒 SSL/HTTPS Setup

### 1. Let's Encrypt Certificate

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Obtain certificate
sudo certbot --nginx -d buahhatipamulang.co.id -d www.buahhatipamulang.co.id

# Test auto-renewal
sudo certbot renew --dry-run
```

### 2. Auto-renewal Setup

```bash
# Add to crontab
sudo crontab -e

# Add this line for daily renewal check
0 12 * * * /usr/bin/certbot renew --quiet
```

### 3. SSL Configuration Check

```bash
# Test SSL configuration
curl -I https://buahhatipamulang.co.id

# Check SSL grade
# Visit: https://www.ssllabs.com/ssltest/
```

---

## 📊 Monitoring & Logging

### 1. Application Monitoring

#### Prometheus Configuration

```yaml
# /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "hospital-app"
    static_configs:
      - targets: ["localhost:8080"]
    metrics_path: "/actuator/prometheus"
    scrape_interval: 30s
```

#### Grafana Dashboard

```json
{
  "dashboard": {
    "title": "Hospital Management System",
    "panels": [
      {
        "title": "Application Health",
        "type": "stat",
        "targets": [
          {
            "expr": "up{job=\"hospital-app\"}"
          }
        ]
      },
      {
        "title": "HTTP Requests",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_server_requests_seconds_count[5m])"
          }
        ]
      }
    ]
  }
}
```

### 2. Log Management

#### Log Rotation

```bash
# /etc/logrotate.d/hospital
/opt/hospital/app/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 hospital hospital
    postrotate
        systemctl reload hospital
    endscript
}
```

#### Centralized Logging

```bash
# Install rsyslog
sudo apt install rsyslog

# Configure rsyslog
sudo nano /etc/rsyslog.d/hospital.conf
```

**Rsyslog Configuration**:

```
# Hospital application logs
if $programname == 'hospital' then /var/log/hospital/app.log
& stop
```

### 3. Health Checks

```bash
# Create health check script
sudo nano /opt/hospital/health-check.sh
```

**Health Check Script**:

```bash
#!/bin/bash

# Check application health
HEALTH_URL="http://localhost:8080/actuator/health"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_URL)

if [ $RESPONSE -eq 200 ]; then
    echo "Application is healthy"
    exit 0
else
    echo "Application health check failed: $RESPONSE"
    exit 1
fi
```

```bash
# Make executable
sudo chmod +x /opt/hospital/health-check.sh

# Add to crontab for monitoring
sudo crontab -e
# Add: */5 * * * * /opt/hospital/health-check.sh
```

---

## 💾 Backup & Recovery

### 1. Database Backup

```bash
# Create backup script
sudo nano /opt/hospital/backup.sh
```

**Backup Script**:

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/opt/hospital/backups"
DB_NAME="hospital"
DB_USER="hospital_user"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p $BACKUP_DIR

# Database backup
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# Application backup
tar -czf $BACKUP_DIR/app_backup_$DATE.tar.gz \
    --exclude=target \
    --exclude=node_modules \
    --exclude=logs \
    /opt/hospital/app

# Clean old backups (keep last 7 days)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
```

### 2. Automated Backup

```bash
# Make executable
sudo chmod +x /opt/hospital/backup.sh

# Add to crontab
sudo crontab -e
# Add: 0 2 * * * /opt/hospital/backup.sh
```

### 3. Recovery Procedures

#### Database Recovery

```bash
# Stop application
sudo systemctl stop hospital

# Restore database
mysql -u hospital_user -p hospital < /opt/hospital/backups/db_backup_20240115_020000.sql

# Start application
sudo systemctl start hospital
```

#### Application Recovery

```bash
# Stop application
sudo systemctl stop hospital

# Restore application files
tar -xzf /opt/hospital/backups/app_backup_20240115_020000.tar.gz -C /

# Rebuild application
cd /opt/hospital/app
mvn clean package -DskipTests

# Start application
sudo systemctl start hospital
```

---

## 🔧 Troubleshooting

### 1. Common Issues

#### Application Won't Start

```bash
# Check logs
sudo journalctl -u hospital -f

# Check Java version
java -version

# Check disk space
df -h

# Check memory
free -h
```

#### Database Connection Issues

```bash
# Test database connection
mysql -u hospital_user -p hospital -e "SELECT 1;"

# Check MySQL status
sudo systemctl status mysql

# Check MySQL logs
sudo tail -f /var/log/mysql/error.log
```

#### Nginx Issues

```bash
# Test configuration
sudo nginx -t

# Check Nginx status
sudo systemctl status nginx

# Check Nginx logs
sudo tail -f /var/log/nginx/error.log
```

### 2. Performance Issues

#### Memory Issues

```bash
# Check memory usage
htop

# Check Java heap
jstat -gc <pid>

# Increase heap size in service file
sudo nano /etc/systemd/system/hospital.service
# Update: -Xmx4g
```

#### Database Performance

```sql
-- Check slow queries
SHOW VARIABLES LIKE 'slow_query_log';
SHOW VARIABLES LIKE 'long_query_time';

-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;
```

### 3. Security Issues

#### SSL Certificate Issues

```bash
# Check certificate validity
sudo certbot certificates

# Renew certificate manually
sudo certbot renew

# Check SSL configuration
openssl s_client -connect buahhatipamulang.co.id:443
```

#### Firewall Issues

```bash
# Check firewall status
sudo ufw status

# Check open ports
sudo netstat -tlnp

# Check iptables
sudo iptables -L
```

### 4. Monitoring Commands

```bash
# System resources
htop
iotop
nethogs

# Application metrics
curl http://localhost:8080/actuator/metrics

# Database connections
mysql -u root -p -e "SHOW PROCESSLIST;"

# Network connections
ss -tulpn | grep :8080
```

---

## 📞 Support

### Emergency Contacts

- **Technical Support**: tech@buahhatipamulang.co.id
- **Emergency**: (021) 1234 5678
- **Documentation**: https://docs.buahhatipamulang.co.id

### Maintenance Schedule

- **Daily**: Health checks and log monitoring
- **Weekly**: Backup verification and performance review
- **Monthly**: Security updates and system maintenance
- **Quarterly**: Full system audit and optimization

### Escalation Procedures

1. **Level 1**: Check logs and restart services
2. **Level 2**: Review configuration and apply fixes
3. **Level 3**: Contact development team
4. **Level 4**: Emergency maintenance window

---

**Version**: 1.0.0
**Last Updated**: January 2024
**Maintainer**: DevOps Team
