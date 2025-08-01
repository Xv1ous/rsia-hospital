# 🚀 Quick Start Guide

Panduan lengkap untuk memulai Hospital Management System dengan cepat.

## 📋 **Prerequisites**

### **Wajib:**

- **Docker Desktop** (Windows/Mac) atau **Docker** (Linux)
- **Git** (untuk download project)

### **Opsional (untuk development):**

- **Java 21** (untuk build project)
- **Maven** (untuk build project)

## 🎯 **Step-by-Step Setup**

### **Step 1: Download Project**

```bash
# Clone repository
git clone <repository-url>
cd hospital

# Verifikasi struktur project
ls -la
```

### **Step 2: Build Project (Pertama Kali)**

**Note:** Jika baru download project, build dulu sebelum start aplikasi.

#### **Windows:**

```bash
# Option 1: Double-click file ini
scripts/simple/BUILD.bat

# Option 2: Use interactive menu
QUICK_ACCESS.bat
# Pilih opsi [1] Build Project
```

#### **Linux/Mac:**

```bash
# Option 1: Double-click atau jalankan
./scripts/simple/build.sh

# Option 2: Use interactive menu
./quick-access.sh
# Pilih opsi [1] Build Project
```

**Expected Output:**

```
========================================
    BUILD COMPLETED SUCCESSFULLY!
========================================

[✓] JAR file created: target/hospital-0.0.1-SNAPSHOT.jar (75M)

🎉 Project built successfully!
```

### **Step 3: Start Application**

#### **Windows:**

```bash
# Option 1: Double-click file ini
scripts/simple/START.bat

# Option 2: Use interactive menu
QUICK_ACCESS.bat
# Pilih opsi [2] Start Application
```

#### **Linux/Mac:**

```bash
# Option 1: Double-click atau jalankan
./scripts/simple/start.sh

# Option 2: Use interactive menu
./quick-access.sh
# Pilih opsi [2] Start Application
```

**Expected Output:**

```
========================================
    SUCCESS! Application is running
========================================

🌐 Open your browser and go to:
   http://localhost:8080

👤 Admin Login:
   Username: admin
   Password: admin123
```

### **Step 4: Akses Aplikasi**

1. **Buka browser** dan kunjungi: http://localhost:8080
2. **Login sebagai admin:**
   - Username: `admin`
   - Password: `admin123`

### **Step 5: Initialize Database (Optional)**

Untuk mengisi database dengan data sample (dokter, jadwal, berita, dll):

#### **Windows:**

```bash
scripts/simple/INITIALIZE-DB.bat
```

#### **Linux/Mac:**

```bash
./scripts/simple/initialize-db.sh
```

**Note:** Proses ini akan menghapus semua data yang ada dan mengisi dengan data sample dari RSIA Buah Hati Pamulang.

## ✅ **Verifikasi Berhasil**

### **✅ Aplikasi Berjalan**

- Browser terbuka otomatis ke http://localhost:8080
- Halaman utama rumah sakit tampil
- Tidak ada error di terminal

### **✅ Admin Login**

- Bisa login dengan `admin` / `admin123`
- Dashboard admin tampil
- Menu kelola dokter, jadwal, berita tersedia

### **✅ Database Terisi (jika initialize)**

- Ada data dokter
- Ada jadwal dokter
- Ada berita
- Ada layanan

## 🔧 **Quick Access Menu**

Untuk kemudahan penggunaan, gunakan menu interaktif:

### **Windows:**

```bash
QUICK_ACCESS.bat
```

### **Linux/Mac:**

```bash
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

## 🚨 **Troubleshooting**

### **Error: Docker is not running**

```bash
# 1. Buka Docker Desktop
# 2. Tunggu sampai status "Docker Desktop is running"
# 3. Jalankan ulang aplikasi
```

### **Error: JAR file not found**

```bash
# Build project dulu
./scripts/simple/build.sh
```

### **Error: Port 8080 already in use**

```bash
# Stop aplikasi dulu
./scripts/simple/stop.sh

# Tunggu 30 detik, lalu jalankan ulang
./scripts/simple/start.sh
```

### **Error: Permission denied**

```bash
# Berikan permission execute
chmod +x scripts/simple/*.sh
chmod +x mvnw
```

## 📊 **Build Statistics**

- **Build Time:** ~30-60 detik (tergantung koneksi internet)
- **JAR Size:** ~75MB (termasuk semua dependencies)
- **Dependencies:** ~150+ libraries
- **Frontend Assets:** Tailwind CSS minified

## 🎯 **Next Steps**

Setelah aplikasi berhasil dijalankan:

1. **📖 Baca [User Guide](USER_GUIDE.md)** - Panduan lengkap penggunaan
2. **🛠️ Baca [Build Guide](BUILD_SCRIPT_GUIDE.md)** - Panduan build project
3. **🚀 Baca [Deployment Guide](DEPLOYMENT_GUIDE.md)** - Panduan deployment
4. **🔧 Baca [API Documentation](API_DOCUMENTATION.md)** - Untuk developer

---

**Happy Coding! 🎉**
