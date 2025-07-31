# Docker Commands - Quick Reference

## 🚀 **Quick Start Commands**

### **1. Build & Deploy (Recommended)**

```bash
# Development environment
./scripts/build-and-deploy.sh dev

# Production environment
./scripts/build-and-deploy.sh prod

# Build only (tanpa deploy)
./scripts/build-and-deploy.sh build
```

### **2. Manual Build & Deploy**

```bash
# 1. Build application (skip frontend)
mvn clean package -DskipTests -Dmaven.paseq.skip=true

# 2. Build Docker image
docker build -f Dockerfile.simple -t hospital-app:latest .

# 3. Start development
docker-compose -f docker-compose.dev.yml up -d

# 4. Start production
docker-compose up -d
```

## 🛠️ **Management Commands**

### **Stop & Clean**

```bash
# Stop containers
docker-compose down
docker-compose -f docker-compose.dev.yml down

# Clean everything
docker-compose down -v --remove-orphans
docker system prune -f
```

### **View Logs**

```bash
# Application logs
docker-compose logs -f hospital-app

# All logs
docker-compose logs -f

# Development logs
docker-compose -f docker-compose.dev.yml logs -f
```

### **Database Operations**

```bash
# Connect to MySQL
docker exec -it hospital-mysql mysql -u hospital_user -p hospital

# Backup database
docker exec hospital-mysql mysqldump -u hospital_user -p hospital > backup.sql

# Restore database
docker exec -i hospital-mysql mysql -u hospital_user -p hospital < backup.sql
```

## 📊 **Monitoring Commands**

### **Status & Health**

```bash
# Container status
docker-compose ps

# Resource usage
docker stats

# Health check
curl http://localhost:8080/
```

### **Troubleshooting**

```bash
# Check what's using port 8080
sudo lsof -i :8080

# Restart specific service
docker-compose restart hospital-app

# View container details
docker inspect hospital-app
```

## 🔧 **Fix Permission Issues**

### **Add User to Docker Group**

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout dan login lagi, atau
newgrp docker
```

### **Use Sudo (Temporary)**

```bash
# Build with sudo
sudo docker build -f Dockerfile.simple -t hospital-app:latest .

# Run with sudo
sudo docker-compose up -d
```

## 📁 **File Structure**

```
hospital/
├── Dockerfile                    # Full build (with Node.js)
├── Dockerfile.simple            # Simple build (recommended)
├── docker-compose.yml           # Production
├── docker-compose.dev.yml       # Development
├── scripts/
│   ├── build-and-deploy.sh      # Build & deploy script
│   └── docker-deploy.sh         # Deploy only script
└── target/                      # Built JAR file
```

## 🌐 **Access URLs**

### **Development**

- **Application:** http://localhost:8080
- **Database:** localhost:3306
- **Admin:** admin/admin123

### **Production**

- **Application:** http://localhost:8080
- **Nginx:** http://localhost:80
- **Database:** localhost:3306

## ⚡ **Quick Commands Summary**

```bash
# 🚀 Start development
./scripts/build-and-deploy.sh dev

# 🏭 Start production
./scripts/build-and-deploy.sh prod

# 🛑 Stop all
docker-compose down

# 📋 View logs
docker-compose logs -f hospital-app

# 🔍 Check status
docker-compose ps

# 🧹 Clean up
docker-compose down -v --remove-orphans
```

## 🆘 **Common Issues & Solutions**

### **1. Port Already in Use**

```bash
sudo lsof -i :8080
sudo kill -9 <PID>
```

### **2. Permission Denied**

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### **3. Build Failed (npm error)**

```bash
# Use simple build
mvn clean package -DskipTests -Dmaven.paseq.skip=true
docker build -f Dockerfile.simple -t hospital-app:latest .
```

### **4. Database Connection Failed**

```bash
# Check database status
docker-compose logs mysql

# Restart database
docker-compose restart mysql
```
