# 🏥 Hospital App - Simple Guide

## 🚀 **Cara Menjalankan Aplikasi (SUPER MUDAH)**

### **Windows:**

1. **Double-click file:** `START.bat`
2. **Tunggu sampai muncul "SUCCESS!"**
3. **Browser akan terbuka otomatis**
4. **Login dengan:** admin / admin123

### **Linux/Mac:**

1. **Double-click file:** `start.sh`
2. **Atau ketik:** `./start.sh`
3. **Tunggu sampai muncul "SUCCESS!"**
4. **Browser akan terbuka otomatis**
5. **Login dengan:** admin / admin123

## 🛑 **Cara Menghentikan Aplikasi**

### **Windows:**

- **Double-click file:** `STOP.bat`

### **Linux/Mac:**

- **Double-click file:** `stop.sh`
- **Atau ketik:** `./stop.sh`

## 🌐 **Akses Aplikasi**

- **URL:** http://localhost:8080
- **Username:** admin
- **Password:** admin123

## ⚠️ **Yang Perlu Diperhatikan**

### **Sebelum Menjalankan:**

1. **Docker Desktop harus sudah terinstall**
2. **Docker Desktop harus sudah running**
3. **Tunggu sampai Docker Desktop siap**

### **Jika Ada Error:**

1. **Pastikan Docker Desktop running**
2. **Restart Docker Desktop**
3. **Jalankan ulang START.bat atau start.sh**

## 📞 **Jika Ada Masalah**

### **Error: "Docker is not running"**

- Buka Docker Desktop
- Tunggu sampai status "Docker Desktop is running"
- Jalankan ulang aplikasi

### **Error: "Port already in use"**

- Jalankan STOP.bat atau stop.sh dulu
- Tunggu 30 detik
- Jalankan ulang START.bat atau start.sh

### **Aplikasi tidak bisa diakses**

- Tunggu 1-2 menit setelah muncul "SUCCESS!"
- Coba refresh browser
- Pastikan tidak ada firewall yang memblokir

## 🎯 **Yang Sudah Termasuk**

✅ **Database MySQL** - Otomatis terinstall dan terkonfigurasi
✅ **Aplikasi Spring Boot** - Otomatis terbuild dan terjalankan
✅ **Data awal** - Dokter, jadwal, dan data lainnya sudah tersedia
✅ **Admin panel** - Untuk mengelola data

## 📁 **File Penting**

- `START.bat` / `start.sh` - Untuk menjalankan aplikasi
- `STOP.bat` / `stop.sh` - Untuk menghentikan aplikasi
- `docker-compose.dev.yml` - Konfigurasi aplikasi
- `README_SIMPLE.md` - Panduan ini

## 🎉 **Selesai!**

Sekarang siapa saja bisa menjalankan aplikasi hospital dengan mudah, tanpa perlu tahu tentang Docker, Java, atau teknologi lainnya!
