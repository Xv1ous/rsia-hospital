# 🔧 Troubleshooting Guide

Panduan lengkap untuk mengatasi masalah yang sering terjadi di Hospital Management System.

## 🚨 **Common Issues**

### **1. Docker Issues**

#### **Error: Docker is not running**

```
ERROR: Docker is not running!
```

**Solution:**

```bash
# 1. Buka Docker Desktop
# 2. Tunggu sampai status "Docker Desktop is running"
# 3. Jalankan ulang aplikasi
./scripts/simple/start.sh
```

#### **Error: Port already in use**

```
Error response from daemon: driver failed programming external connectivity on endpoint
```

**Solution:**

```bash
# Stop aplikasi dulu
./scripts/simple/stop.sh

# Tunggu 30 detik
sleep 30

# Jalankan ulang
./scripts/simple/start.sh
```

#### **Error: Permission denied**

```
Got permission denied while trying to connect to the Docker daemon socket
```

**Solution:**

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout dan login ulang, atau
newgrp docker
```

### **2. Build Issues**

#### **Error: JAR file not found**

```
❌ JAR file not found!
The application needs to be built first.
```

**Solution:**

```bash
# Build project dulu
./scripts/simple/build.sh

# Atau manual
./mvnw clean package -DskipTests
```

#### **Error: Maven wrapper not found**

```
Maven wrapper (mvnw) not found!
```

**Solution:**

```bash
# Pastikan file mvnw ada
ls -la mvnw

# Jika tidak ada, download ulang project
git clone <repository-url>
cd hospital
```

#### **Error: Java not found**

```
Error: JAVA_HOME is not defined correctly.
```

**Solution:**

```bash
# Install Java 21
# Ubuntu/Debian
sudo apt install openjdk-21-jdk

# CentOS/RHEL
sudo yum install java-21-openjdk-devel

# macOS
brew install openjdk@21

# Set JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
```

#### **Error: Permission denied on scripts**

```
Permission denied: ./scripts/simple/build.sh
```

**Solution:**

```bash
# Berikan permission execute
chmod +x scripts/simple/*.sh
chmod +x mvnw
```

### **3. Database Issues**

#### **Error: Database connection failed**

```
Communications link failure
```

**Solution:**

```bash
# Restart database container
docker-compose -f docker/docker-compose.dev.yml restart mysql

# Atau restart semua
./scripts/simple/restart.sh
```

#### **Error: Database not initialized**

```
Table 'hospital.doctor' doesn't exist
```

**Solution:**

```bash
# Initialize database
./scripts/simple/initialize-db.sh
```

#### **Error: Database access denied**

```
Access denied for user 'hospital_user'@'localhost'
```

**Solution:**

```bash
# Reset database
docker-compose -f docker/docker-compose.dev.yml down -v
./scripts/simple/initialize-db.sh
```

### **4. Application Issues**

#### **Error: Application not starting**

```
Application failed to start
```

**Solution:**

```bash
# Check logs
docker-compose -f docker/docker-compose.dev.yml logs hospital-app

# Check if JAR exists
ls -la target/hospital-0.0.1-SNAPSHOT.jar

# Rebuild if needed
./scripts/simple/build.sh
```

#### **Error: Port 8080 already in use**

```
BindException: Address already in use
```

**Solution:**

```bash
# Check what's using port 8080
lsof -i :8080

# Kill the process
sudo kill -9 <PID>

# Or stop all containers
docker stop $(docker ps -aq)
```

#### **Error: Application health check failed**

```
Health check failed
```

**Solution:**

```bash
# Check application logs
docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app

# Restart application
./scripts/simple/restart.sh
```

### **5. Frontend Issues**

#### **Error: CSS not loading**

```
Failed to load resource: the server responded with a status of 404
```

**Solution:**

```bash
# Rebuild frontend assets
cd src/main/frontend
npm install
npm run build
cd ../../..

# Rebuild project
./scripts/simple/build.sh
```

#### **Error: JavaScript errors**

```
Uncaught TypeError: Cannot read property of undefined
```

**Solution:**

```bash
# Check browser console for specific errors
# Clear browser cache
# Try different browser
```

## 🔍 **Debugging Steps**

### **1. Check Application Status**

```bash
# Check container status
docker-compose -f docker/docker-compose.dev.yml ps

# Check application logs
docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app

# Check database logs
docker-compose -f docker/docker-compose.dev.yml logs -f mysql
```

### **2. Check System Resources**

```bash
# Check Docker resources
docker stats

# Check disk space
df -h

# Check memory usage
free -h
```

### **3. Check Network Connectivity**

```bash
# Check if ports are open
netstat -tulpn | grep :8080
netstat -tulpn | grep :3307

# Test application endpoint
curl http://localhost:8080/actuator/health
```

### **4. Check Database**

```bash
# Connect to database
docker exec -it hospital-mysql-dev mysql -u hospital_user -p hospital

# Check tables
SHOW TABLES;

# Check data
SELECT COUNT(*) FROM doctor;
```

## 🛠️ **Reset Solutions**

### **Complete Reset**

```bash
# Stop everything
./scripts/simple/stop.sh

# Remove all containers and volumes
docker-compose -f docker/docker-compose.dev.yml down -v

# Remove images
docker rmi hospital-hospital-app-dev

# Rebuild and start
./scripts/simple/build.sh
./scripts/simple/initialize-db.sh
./scripts/simple/start.sh
```

### **Database Reset**

```bash
# Stop application
./scripts/simple/stop.sh

# Remove database volume
docker volume rm docker_mysql_data_dev

# Start fresh
./scripts/simple/start.sh
./scripts/simple/initialize-db.sh
```

### **Application Reset**

```bash
# Stop application
./scripts/simple/stop.sh

# Remove application container
docker rm hospital-app-dev

# Rebuild and start
./scripts/simple/build.sh
./scripts/simple/start.sh
```

## 📊 **Health Checks**

### **Application Health**

```bash
# Check application health
curl http://localhost:8080/actuator/health

# Expected response:
{
  "status": "UP",
  "components": {
    "db": {"status": "UP"},
    "diskSpace": {"status": "UP"}
  }
}
```

### **Database Health**

```bash
# Check database connection
docker exec hospital-mysql-dev mysqladmin ping -h localhost -u hospital_user -p

# Expected response: mysqld is alive
```

### **Container Health**

```bash
# Check container status
docker-compose -f docker/docker-compose.dev.yml ps

# Expected output:
# Name                Command               State    Ports
# hospital-app-dev    java -jar app.jar     Up       0.0.0.0:8080->8080/tcp
# hospital-mysql-dev  docker-entrypoint.sh  Up       0.0.0.0:3307->3306/tcp
```

## 🚨 **Emergency Procedures**

### **System Won't Start**

```bash
# 1. Stop everything
docker stop $(docker ps -aq)
docker system prune -f

# 2. Restart Docker
# Windows/Mac: Restart Docker Desktop
# Linux: sudo systemctl restart docker

# 3. Start fresh
./scripts/simple/build.sh
./scripts/simple/start.sh
```

### **Database Corruption**

```bash
# 1. Stop application
./scripts/simple/stop.sh

# 2. Remove database volume
docker volume rm docker_mysql_data_dev

# 3. Start fresh
./scripts/simple/start.sh
./scripts/simple/initialize-db.sh
```

### **Application Crashes**

```bash
# 1. Check logs
docker-compose -f docker/docker-compose.dev.yml logs hospital-app

# 2. Restart application
./scripts/simple/restart.sh

# 3. If still crashes, rebuild
./scripts/simple/build.sh
./scripts/simple/start.sh
```

## 📞 **Getting Help**

### **Before Asking for Help**

1. **Check this troubleshooting guide**
2. **Check application logs**
3. **Try reset solutions**
4. **Note down error messages**

### **When Reporting Issues**

- **OS and version**
- **Docker version**
- **Java version**
- **Error messages**
- **Steps to reproduce**
- **What you've tried**

### **Useful Commands for Debugging**

```bash
# Get system info
docker version
java -version
./mvnw -version

# Get logs
docker-compose -f docker/docker-compose.dev.yml logs --tail=100

# Check resources
docker stats
df -h
free -h
```

---

**💡 Tip:** Most issues can be resolved by restarting the application or resetting the environment!
