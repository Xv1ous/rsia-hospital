# 🏥 Hospital Management System

Aplikasi manajemen rumah sakit berbasis Spring Boot dengan interface web yang user-friendly.

## 🚀 **Quick Start (SUPER MUDAH)**

### **Windows:**

```bash
# Double-click file ini
scripts/simple/START.bat
```

### **Linux/Mac:**

```bash
# Double-click atau jalankan
./scripts/simple/start.sh
```

### **Akses Aplikasi:**

- **URL:** http://localhost:8080
- **Admin:** admin / admin123

## 📁 **Struktur Project**

```
hospital/
├── 📁 src/                    # Source code aplikasi
│   ├── main/java/            # Java source code
│   ├── main/resources/       # Konfigurasi & assets
│   └── main/frontend/        # Frontend assets
├── 📁 docs/                  # Dokumentasi lengkap
│   ├── README_SIMPLE.md      # Panduan simple untuk user
│   ├── USER_GUIDE.md         # Panduan lengkap user
│   ├── API_DOCUMENTATION.md  # Dokumentasi API
│   └── ...                   # Dokumentasi lainnya
├── 📁 scripts/               # Script untuk menjalankan aplikasi
│   ├── simple/               # Script simple (double-click)
│   │   ├── START.bat         # Start aplikasi (Windows)
│   │   ├── STOP.bat          # Stop aplikasi (Windows)
│   │   ├── start.sh          # Start aplikasi (Linux/Mac)
│   │   └── stop.sh           # Stop aplikasi (Linux/Mac)
│   └── advanced/             # Script advanced untuk developer
├── 📁 docker/                # Konfigurasi Docker
│   ├── docker-compose.yml    # Production setup
│   ├── docker-compose.dev.yml # Development setup
│   ├── Dockerfile            # Full build
│   └── Dockerfile.simple     # Simple build
├── 📁 config/                # Konfigurasi tambahan
│   ├── nginx.conf            # Nginx configuration
│   ├── env.example           # Environment variables example
│   └── Makefile              # Build automation
├── pom.xml                   # Maven configuration
└── README.md                 # File ini
```

## 🎯 **Fitur Utama**

### **Untuk Pasien:**

- 📅 **Janji Temu** - Buat janji dengan dokter
- 👨‍⚕️ **Jadwal Dokter** - Lihat jadwal praktik dokter
- 📰 **Berita** - Informasi terbaru rumah sakit
- ⭐ **Review** - Berikan ulasan dan rating

### **Untuk Admin:**

- 👨‍⚕️ **Kelola Dokter** - Tambah, edit, hapus data dokter
- 📅 **Kelola Jadwal** - Atur jadwal praktik dokter
- 📰 **Kelola Berita** - Publikasi berita rumah sakit
- 📊 **Dashboard** - Monitoring sistem

## 🛠️ **Teknologi**

- **Backend:** Spring Boot 3.x, Java 21
- **Database:** MySQL 8.0
- **Frontend:** Thymeleaf, Bootstrap, JavaScript
- **Container:** Docker & Docker Compose
- **Build Tool:** Maven

## 📋 **Prerequisites**

- **Docker Desktop** (Windows/Mac) atau **Docker** (Linux)
- **Java 21** (untuk development)
- **Maven** (untuk development)

## 🚀 **Cara Menjalankan**

### **1. Simple (Recommended untuk User)**

```bash
# Windows
scripts/simple/START.bat

# Linux/Mac
./scripts/simple/start.sh
```

### **2. Advanced (Untuk Developer)**

```bash
# Development
./scripts/advanced/build-and-deploy.sh dev

# Production
./scripts/advanced/build-and-deploy.sh prod
```

### **3. Manual**

```bash
# Build aplikasi
mvn clean package -DskipTests

# Build Docker image
docker build -f docker/Dockerfile.simple -t hospital-app:latest .

# Start containers
docker-compose -f docker/docker-compose.dev.yml up -d
```

## 🛑 **Cara Menghentikan**

```bash
# Windows
scripts/simple/STOP.bat

# Linux/Mac
./scripts/simple/stop.sh

# Atau manual
docker-compose -f docker/docker-compose.dev.yml down
```

## 📊 **Monitoring**

```bash
# Lihat status container
docker-compose -f docker/docker-compose.dev.yml ps

# Lihat logs aplikasi
docker-compose -f docker/docker-compose.dev.yml logs -f hospital-app

# Lihat logs database
docker-compose -f docker/docker-compose.dev.yml logs -f mysql
```

## 🔧 **Troubleshooting**

### **Docker tidak running:**

1. Buka Docker Desktop
2. Tunggu sampai status "Docker Desktop is running"
3. Jalankan ulang aplikasi

### **Port sudah digunakan:**

```bash
# Stop aplikasi dulu
./scripts/simple/stop.sh

# Tunggu 30 detik, lalu jalankan ulang
./scripts/simple/start.sh
```

### **Database error:**

```bash
# Restart database
docker-compose -f docker/docker-compose.dev.yml restart mysql
```

## 📚 **Dokumentasi**

- **📖 [Panduan Simple](docs/README_SIMPLE.md)** - Untuk user non-teknis
- **👤 [User Guide](docs/USER_GUIDE.md)** - Panduan lengkap penggunaan
- **🔧 [API Documentation](docs/API_DOCUMENTATION.md)** - Dokumentasi API
- **🚀 [Deployment Guide](docs/DEPLOYMENT_GUIDE.md)** - Panduan deployment
- **🐳 [Docker Guide](docs/DOCKER_DEPLOYMENT.md)** - Panduan Docker

## 🤝 **Kontribusi**

1. Fork project ini
2. Buat branch fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 **License**

Project ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detail.

## 📞 **Support**

Jika ada pertanyaan atau masalah:

1. Cek dokumentasi di folder `docs/`
2. Cek troubleshooting section di atas
3. Buat issue di repository ini
