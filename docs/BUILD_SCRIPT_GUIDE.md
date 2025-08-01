# 🛠️ Build Script Guide

Panduan lengkap untuk menggunakan script build project Hospital Management System.

## 📋 Overview

Script build dibuat untuk memudahkan proses build project tanpa perlu mengingat command Maven yang panjang. Script ini otomatis melakukan:

1. **Clean** - Membersihkan build sebelumnya
2. **Dependency Resolution** - Menginstall dependencies
3. **Frontend Build** - Build assets CSS/JS
4. **JAR Creation** - Membuat file JAR executable

## 🚀 Cara Menggunakan

### **Linux/Mac**

```bash
# Build project
./scripts/simple/build.sh

# Atau dari quick access menu
./quick-access.sh
# Pilih opsi [1] Build Project
```

### **Windows**

```batch
# Build project
scripts\simple\BUILD.bat

# Atau dari quick access menu
QUICK_ACCESS.bat
# Pilih opsi [1] Build Project
```

## 📁 File yang Dibuat

Setelah build berhasil, file berikut akan dibuat:

```
target/
├── hospital-0.0.1-SNAPSHOT.jar     # File JAR utama (75MB)
├── hospital-0.0.1-SNAPSHOT.jar.original
├── classes/                        # Compiled Java classes
├── test-classes/                   # Compiled test classes
└── generated-sources/              # Generated sources
```

## ⚡ Quick Commands

### **Build Saja**

```bash
./mvnw clean package -DskipTests
```

### **Build + Run**

```bash
./mvnw clean package -DskipTests
./scripts/simple/start.sh
```

### **Build + Initialize DB**

```bash
./mvnw clean package -DskipTests
./scripts/simple/initialize-db.sh
```

## 🔧 Troubleshooting

### **Error: JAR file not found**

```bash
# Pastikan build sudah dilakukan
./scripts/simple/build.sh

# Atau manual
./mvnw clean package -DskipTests
```

### **Error: Maven wrapper not found**

```bash
# Pastikan file mvnw ada di root project
ls -la mvnw

# Jika tidak ada, download ulang project
git clone <repository-url>
```

### **Error: Permission denied**

```bash
# Berikan permission execute
chmod +x scripts/simple/build.sh
chmod +x mvnw
```

### **Error: Java not found**

```bash
# Install Java 21 atau lebih tinggi
# Ubuntu/Debian
sudo apt install openjdk-21-jdk

# CentOS/RHEL
sudo yum install java-21-openjdk-devel

# macOS
brew install openjdk@21
```

## 📊 Build Statistics

- **Build Time**: ~30-60 detik (tergantung koneksi internet)
- **JAR Size**: ~75MB (termasuk semua dependencies)
- **Dependencies**: ~150+ libraries
- **Frontend Assets**: Tailwind CSS minified

## 🎯 Workflow Lengkap

### **Untuk User Baru**

1. **Download Project**

   ```bash
   git clone <repository-url>
   cd hospital
   ```

2. **Build Project**

   ```bash
   ./scripts/simple/build.sh
   ```

3. **Start Application**

   ```bash
   ./scripts/simple/start.sh
   ```

4. **Initialize Database (Optional)**
   ```bash
   ./scripts/simple/initialize-db.sh
   ```

### **Untuk Development**

1. **Build**

   ```bash
   ./scripts/simple/build.sh
   ```

2. **Start**

   ```bash
   ./scripts/simple/start.sh
   ```

3. **Stop**

   ```bash
   ./scripts/simple/stop.sh
   ```

4. **Restart**
   ```bash
   ./scripts/simple/restart.sh
   ```

## 🔄 Integration dengan Script Lain

Script build terintegrasi dengan script lainnya:

- **start.sh** - Otomatis cek JAR sebelum start
- **initialize-db.sh** - Tidak perlu build ulang
- **quick-access.sh** - Menu build di opsi pertama

## 📝 Notes

- **JAR file tidak di-commit** ke Git (normal untuk project Java)
- **Build harus dilakukan** setiap kali ada perubahan source code
- **Dependencies di-cache** oleh Maven untuk build lebih cepat
- **Frontend assets** di-build otomatis saat build backend

## 🆘 Support

Jika mengalami masalah:

1. Cek log error di terminal
2. Pastikan Java 21+ terinstall
3. Pastikan Maven wrapper ada
4. Coba build manual: `./mvnw clean package -DskipTests`
5. Buka issue di repository

---

**Happy Building! 🎉**
