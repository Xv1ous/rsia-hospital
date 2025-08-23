# 🏥 RSIA Buah Hati Pamulang - Hospital Management System

Aplikasi manajemen rumah sakit berbasis Spring Boot dengan interface web yang user-friendly. Mendukung **cross-platform development** (Windows, Linux, macOS) dengan build system yang terintegrasi.

## ✨ **New Features**

- 🔄 **Cross-Platform Build** - Otomatis mendeteksi OS dan menggunakan tools yang sesuai
- 🎨 **Modern Frontend Pipeline** - Tailwind CSS dengan auto-compilation
- 🛠️ **Developer-Friendly** - Hot reload dan file watching untuk development
- 📦 **Production Ready** - Optimized builds untuk deployment

## 🚀 **Quick Start**

### **Prerequisites**

- **Java 21** - Required untuk Spring Boot 3.5.3
- **Node.js & npm** - Untuk frontend asset building
- **Docker Desktop** (opsional) - Untuk containerized deployment

### **Pertama Kali Setup**

1. **Download & Build**

   ```bash
   git clone <repository-url>
   cd rsia-hospital

   # Windows - Cross-platform build
   .\mvnw.cmd clean package -DskipTests

   # Linux/Mac - Cross-platform build
   ./mvnw clean package -DskipTests
   
   # Or use convenience scripts
   scripts/simple/BUILD.bat      # Windows
   ./scripts/simple/build.sh     # Linux/Mac
   ```

2. **Start Application**

   ```bash
   # Direct JAR execution
   java -jar target/hospital-0.0.1-SNAPSHOT.jar
   
   # Or use convenience scripts
   scripts/simple/START.bat      # Windows
   ./scripts/simple/start.sh     # Linux/Mac
   ```

3. **Development Mode** (with hot reload)

   ```bash
   # Windows
   .\mvnw.cmd paseq:exec@dev

   # Linux/Mac
   ./mvnw paseq:exec@dev
   ```

4. **Akses Aplikasi**
   - **URL:** http://localhost:8080
   - **Admin:** `admin` / `admin123`

### **Quick Access Menu**

```bash
# Windows
QUICK_ACCESS.bat

# Linux/Mac
./quick-access.sh
```

## 📚 **Dokumentasi Lengkap**

### **Build & Development**
- **[🔧 Cross-Platform Build](docs/CROSS_PLATFORM_BUILD.md)** - **NEW!** Panduan build lintas platform
- **[🛠️ Build Troubleshooting](docs/BUILD_TROUBLESHOOTING.md)** - **NEW!** Solusi masalah build
- **[🛠️ Build Guide](docs/BUILD_SCRIPT_GUIDE.md)** - Panduan build project
- **[🚀 Deployment Guide](docs/DEPLOYMENT_GUIDE.md)** - Panduan deployment

### **Usage & Development**
- **[📖 User Guide](docs/USER_GUIDE.md)** - Panduan lengkap penggunaan
- **[🐳 Docker Guide](docs/DOCKER_DEPLOYMENT.md)** - Panduan Docker
- **[🔧 API Documentation](docs/API_DOCUMENTATION.md)** - Dokumentasi API
- **[📋 Project Structure](PROJECT_STRUCTURE.md)** - Struktur project
- **[🆘 Troubleshooting](docs/TROUBLESHOOTING.md)** - General troubleshooting

## 🎯 **Fitur Utama**

- 📅 **Janji Temu** - Buat janji dengan dokter
- 👨‍⚕️ **Jadwal Dokter** - Lihat jadwal praktik dokter
- 📰 **Berita** - Informasi terbaru rumah sakit
- ⭐ **Review** - Berikan ulasan dan rating
- 👨‍⚕️ **Admin Panel** - Kelola dokter, jadwal, berita

## 🛠️ **Teknologi**

- **Backend:** Spring Boot 3.5.3, Java 21
- **Database:** MySQL 8.0
- **Frontend:** Thymeleaf, Tailwind CSS 3.x, DaisyUI, Flowbite
- **Build Tools:** Maven, npm, cross-env
- **Development:** Hot reload, file watching, cross-platform builds
- **Container:** Docker & Docker Compose

## 📞 **Support**

- **Issues:** [GitHub Issues](https://github.com/your-repo/issues)
- **Documentation:** [docs/](docs/) folder
- **Quick Help:** [Troubleshooting Guide](docs/TROUBLESHOOTING.md)

---

**Made with ❤️ for RSIA Buah Hati Pamulang**
