# ⚡ Commands Reference

Referensi lengkap semua command dan script yang tersedia di Hospital Management System.

## 🛠️ **Build Commands**

### **Script Build**

```bash
# Windows
scripts/simple/BUILD.bat

# Linux/Mac
./scripts/simple/build.sh

# Manual
./mvnw clean package -DskipTests
```

### **Build Statistics**

- **Build Time:** ~30-60 detik
- **JAR Size:** ~75MB
- **Dependencies:** ~150+ libraries

## 🚀 **Application Commands**

### **Start Application**

```bash
# Windows
scripts/simple/START.bat

# Linux/Mac
./scripts/simple/start.sh

# Advanced (Developer)
./scripts/advanced/build-and-deploy.sh dev

# Manual
docker-compose -f docker/docker-compose.dev.yml up -d
```

### **Stop Application**

```bash
# Windows
scripts/simple/STOP.bat

# Linux/Mac
./scripts/simple/stop.sh

# Manual
docker-compose -f docker/docker-compose.dev.yml down
```

### **Restart Application**

```bash
# Windows
scripts/simple/RESTART.bat

# Linux/Mac
./scripts/simple/restart.sh

# Manual
docker-compose -f docker/docker-compose.dev.yml restart
```

## 📊 **Monitoring Commands**

### **Check Status**

```bash
# Container status
docker-compose -f docker/docker-compose.dev.yml ps

# Application logs
docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app

# Database logs
docker-compose -f docker/docker-compose.dev.yml logs -f mysql

# All logs
docker-compose -f docker/docker-compose.dev.yml logs -f
```

### **Health Check**

```bash
# Application health
curl http://localhost:8080/actuator/health

# Database health
docker exec hospital-mysql-dev mysqladmin ping -h localhost -u hospital_user -p
```

## 🗄️ **Database Commands**

### **Initialize Database**

```bash
# Windows
scripts/simple/INITIALIZE-DB.bat

# Linux/Mac
./scripts/simple/initialize-db.sh
```

### **Database Access**

```bash
# Windows
scripts/simple/MYSQL-ACCESS.bat

# Linux/Mac
./scripts/simple/mysql-access.sh

# Direct connection
mysql -h localhost -P 3307 -u hospital_user -p hospital
```

### **Database Backup**

```bash
# Windows
scripts/simple/BACKUP-DB.bat

# Linux/Mac
./scripts/simple/backup-db.sh
```

### **Database Commands**

```bash
# Connect to database
docker exec -it hospital-mysql-dev mysql -u hospital_user -p hospital

# View tables
SHOW TABLES;

# View data
SELECT COUNT(*) FROM doctor;
SELECT COUNT(*) FROM doctor_schedule;
SELECT COUNT(*) FROM services;
SELECT COUNT(*) FROM news;
SELECT COUNT(*) FROM reviews;
SELECT COUNT(*) FROM appointments;
SELECT COUNT(*) FROM users;
```

## 🔧 **Development Commands**

### **Advanced Scripts**

```bash
# Development environment
./scripts/advanced/dev.sh start

# Build and deploy
./scripts/advanced/build-and-deploy.sh dev

# Production deployment
./scripts/advanced/build-and-deploy.sh prod

# Docker deployment
./scripts/advanced/docker-deploy.sh
```

### **Maven Commands**

```bash
# Clean build
./mvnw clean

# Compile
./mvnw compile

# Package
./mvnw package -DskipTests

# Run tests
./mvnw test

# Install dependencies
./mvnw dependency:resolve

# Run application
./mvnw spring-boot:run
```

### **Frontend Commands**

```bash
# Install dependencies
cd src/main/frontend
npm install

# Build CSS
npm run build

# Watch for changes
npm run watch
```

## 🐳 **Docker Commands**

### **Container Management**

```bash
# List containers
docker ps -a

# Stop all containers
docker stop $(docker ps -aq)

# Remove all containers
docker rm $(docker ps -aq)

# Remove all images
docker rmi $(docker images -q)

# Clean up system
docker system prune -a
```

### **Volume Management**

```bash
# List volumes
docker volume ls

# Remove database volume
docker volume rm docker_mysql_data_dev

# Backup volume
docker run --rm -v docker_mysql_data_dev:/data -v $(pwd):/backup alpine tar czf /backup/mysql_backup.tar.gz -C /data .
```

### **Network Management**

```bash
# List networks
docker network ls

# Inspect network
docker network inspect docker_hospital-network-dev
```

## 🔍 **Debugging Commands**

### **Log Analysis**

```bash
# Follow application logs
docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app

# Follow database logs
docker-compose -f docker/docker-compose.dev.yml logs -f mysql

# View last 100 lines
docker-compose -f docker/docker-compose.dev.yml logs --tail=100 hospital-app

# Search for errors
docker-compose -f docker/docker-compose.dev.yml logs hospital-app | grep ERROR
```

### **Container Inspection**

```bash
# Enter application container
docker exec -it hospital-app-dev /bin/sh

# Enter database container
docker exec -it hospital-mysql-dev /bin/bash

# Check container resources
docker stats hospital-app-dev hospital-mysql-dev
```

### **Port Checking**

```bash
# Check if port 8080 is in use
lsof -i :8080

# Check if port 3307 is in use
lsof -i :3307

# Check all ports
netstat -tulpn | grep LISTEN
```

## 🔧 **Quick Access Menu**

### **Interactive Menu**

```bash
# Windows
QUICK_ACCESS.bat

# Linux/Mac
./quick-access.sh
```

**Menu Options:**

1. **🛠️ Build Project** - Build project
2. **🚀 Start Application** - Start aplikasi
3. **🛑 Stop Application** - Stop aplikasi
4. **🔄 Restart Application** - Restart aplikasi
5. **📊 View Application Status** - Cek status
6. **📋 View Application Logs** - Lihat log
7. **🗄️ MySQL Database Access** - Akses database
8. **🗄️ Initialize Database** - Reset & load data sample
9. **📚 Open Documentation** - Buka dokumentasi
10. **📖 Open Simple Guide** - Buka panduan simple

## 📋 **Command Categories**

### **🛠️ Build & Development**

- Build project
- Compile code
- Run tests
- Package application

### **🚀 Application Management**

- Start application
- Stop application
- Restart application
- Check status

### **📊 Monitoring & Logs**

- View logs
- Check health
- Monitor resources
- Debug issues

### **🗄️ Database Operations**

- Initialize database
- Backup database
- Access database
- Manage data

### **🐳 Docker Operations**

- Container management
- Volume management
- Network management
- System cleanup

## 🎯 **Common Workflows**

### **First Time Setup**

```bash
git clone <repository-url>
cd hospital
./scripts/simple/build.sh
./scripts/simple/start.sh
./scripts/simple/initialize-db.sh
```

### **Daily Development**

```bash
./scripts/simple/start.sh
# ... work on code ...
./scripts/simple/stop.sh
```

### **Reset Environment**

```bash
./scripts/simple/stop.sh
./scripts/simple/initialize-db.sh
./scripts/simple/start.sh
```

### **Debug Issues**

```bash
docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app
docker exec -it hospital-app-dev /bin/sh
```

---

**💡 Tip:** Gunakan Quick Access Menu untuk kemudahan penggunaan!
