# 🪟 Windows Deployment Guide - Hospital App

## 📋 **Prerequisites**

### **1. Install Required Software**

**Docker Desktop for Windows:**

- Download dari: https://www.docker.com/products/docker-desktop
- Install dan restart komputer
- Pastikan WSL2 integration aktif

**Java Development Kit (JDK):**

- Download OpenJDK 21 atau Oracle JDK 21
- Set JAVA_HOME environment variable

**Maven:**

- Download Apache Maven
- Add Maven ke PATH environment variable

**Git Bash (Optional but Recommended):**

- Download dari: https://git-scm.com/download/win
- Lebih nyaman untuk menjalankan script Linux

## 🚀 **Quick Start - Windows**

### **Method 1: Using Windows Batch Script (Easiest)**

```cmd
# Double click file ini atau jalankan di CMD
scripts\windows-deploy.bat
```

### **Method 2: Using Git Bash**

```bash
# Buka Git Bash di folder project
cd /c/Users/[YourUsername]/Documents/hospital

# Jalankan script
./scripts/build-and-deploy.sh dev
```

### **Method 3: Manual Commands**

```cmd
# Build aplikasi
mvn clean package -DskipTests

# Build Docker image
docker build -f Dockerfile.simple -t hospital-app:latest .

# Start containers
docker-compose -f docker-compose.dev.yml up -d
```

## 🛠️ **Management Commands**

### **Start Application**

```cmd
# Menggunakan batch script
scripts\windows-deploy.bat

# Atau manual
docker-compose -f docker-compose.dev.yml up -d
```

### **Stop Application**

```cmd
# Menggunakan batch script
scripts\windows-stop.bat

# Atau manual
docker-compose down
```

### **View Status**

```cmd
docker-compose ps
```

### **View Logs**

```cmd
docker-compose logs -f hospital-app
```

### **Restart Application**

```cmd
docker-compose restart
```

## 🌐 **Access URLs**

- **Application:** http://localhost:8080
- **Database:** localhost:3307
- **Admin Login:** admin / admin123

## 🔧 **Troubleshooting Windows**

### **1. Docker Desktop Not Running**

```
Error: Docker is not running!
```

**Solution:**

1. Buka Docker Desktop
2. Tunggu sampai status "Docker Desktop is running"
3. Pastikan WSL2 integration aktif di Settings

### **2. Port Already in Use**

```
Error: Port 8080 is already in use
```

**Solution:**

```cmd
# Cek port yang digunakan
netstat -ano | findstr :8080

# Kill process
taskkill /PID [PID_NUMBER] /F
```

### **3. Permission Denied**

```
Error: Permission denied
```

**Solution:**

1. Jalankan CMD/PowerShell sebagai Administrator
2. Atau gunakan Git Bash

### **4. Maven Not Found**

```
Error: 'mvn' is not recognized
```

**Solution:**

1. Install Maven
2. Add Maven ke PATH environment variable
3. Restart CMD/PowerShell

### **5. Java Not Found**

```
Error: 'java' is not recognized
```

**Solution:**

1. Install JDK 21
2. Set JAVA_HOME environment variable
3. Add Java ke PATH

## 📁 **File Structure for Windows**

```
hospital/
├── scripts/
│   ├── windows-deploy.bat      # Windows deployment script
│   ├── windows-stop.bat        # Windows stop script
│   └── build-and-deploy.sh     # Linux/Mac script
├── docker-compose.dev.yml      # Development configuration
├── docker-compose.yml          # Production configuration
├── Dockerfile.simple           # Simple Docker build
└── WINDOWS_GUIDE.md           # This guide
```

## ⚡ **Quick Commands Summary**

```cmd
# 🚀 Start application
scripts\windows-deploy.bat

# 🛑 Stop application
scripts\windows-stop.bat

# 📋 View status
docker-compose ps

# 📊 View logs
docker-compose logs -f hospital-app

# 🔄 Restart
docker-compose restart
```

## 🆘 **Common Issues & Solutions**

### **WSL2 Integration Issues**

1. Buka Docker Desktop Settings
2. Go to Resources > WSL Integration
3. Enable integration with your WSL2 distro

### **Antivirus Blocking Docker**

1. Add Docker Desktop ke antivirus whitelist
2. Allow Docker processes in Windows Defender

### **Slow Performance**

1. Ensure WSL2 is being used (not WSL1)
2. Increase memory allocation in Docker Desktop settings
3. Use SSD storage for Docker volumes

### **Network Issues**

```cmd
# Reset Docker network
docker network prune -f

# Restart Docker Desktop
```

## 📞 **Support**

Jika mengalami masalah:

1. Cek Docker Desktop logs
2. Restart Docker Desktop
3. Restart komputer jika diperlukan
4. Pastikan semua prerequisites terinstall dengan benar
