# RSIA Buah Hati Pamulang

Website resmi RSIA Buah Hati Pamulang - Pelayanan Kesehatan Modern & Terpercaya

## 🏥 Tentang Project

Website ini dibangun untuk RSIA Buah Hati Pamulang dengan fitur-fitur modern yang memudahkan pasien dalam mengakses informasi layanan kesehatan, jadwal dokter, dan informasi kontak.

## 🚀 Fitur Utama

- **Landing Page Modern** dengan desain responsif
- **Jadwal Dokter** dengan filter berdasarkan spesialisasi
- **Status Dokter** - informasi cuti dan ketersediaan dokter
- **Informasi Layanan** rumah sakit
- **Testimoni Pasien** untuk membangun kepercayaan
- **Kontak & Lokasi** dengan integrasi Google Maps
- **Admin Panel** untuk manajemen konten

## 🛠️ Tech Stack

### Backend

- **Spring Boot 3.5.3** - Framework Java
- **Spring Data JPA** - ORM dan database access
- **MySQL** - Database
- **Thymeleaf** - Template engine
- **Lombok** - Boilerplate code reduction

### Frontend

- **Tailwind CSS** - Utility-first CSS framework
- **JavaScript (Vanilla)** - Interaktivitas client-side
- **HTML5** - Markup
- **Responsive Design** - Mobile-first approach

## 📋 Prerequisites

Sebelum menjalankan project, pastikan Anda memiliki:

- **Java 21** atau lebih tinggi
- **Maven 3.6+**
- **MySQL 8.0+**
- **Node.js 18+** (untuk Tailwind CSS)

## 🔧 Installation & Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd hospital
```

### 2. Setup Database

```sql
CREATE DATABASE hospital;
```

### 3. Konfigurasi Database

Edit file `src/main/resources/application.properties`:

```properties
spring.datasource.username=your_username
spring.datasource.password=your_password
```

### 4. Install Dependencies

```bash
# Install Java dependencies
mvn clean install

# Install Frontend dependencies
cd src/main/frontend
npm install
```

### 5. Build Frontend Assets

```bash
# Dari root project
mvn compile
```

### 6. Run Application

```bash
# Development mode dengan hot reload
mvn spring-boot:run

# Atau menggunakan Maven wrapper
./mvnw spring-boot:run
```

Aplikasi akan berjalan di `http://localhost:8080`

## 📁 Project Structure

```
hospital/
├── src/
│   ├── main/
│   │   ├── java/com/example/hospital/
│   │   │   ├── controller/          # REST Controllers
│   │   │   ├── entity/              # JPA Entities
│   │   │   ├── repository/          # Data Access Layer
│   │   │   └── HospitalApplication.java
│   │   ├── resources/
│   │   │   ├── templates/           # Thymeleaf templates
│   │   │   │   ├── fragments/       # Reusable components
│   │   │   │   ├── admin/           # Admin pages
│   │   │   │   └── user/            # User pages
│   │   │   ├── static/              # Static assets
│   │   │   ├── db/migration/        # Database migrations
│   │   │   └── application.properties
│   │   └── frontend/                # Tailwind CSS source
│   └── test/                        # Unit tests
├── pom.xml                          # Maven configuration
└── README.md
```

## 🎨 Customization

### Styling

- Edit `src/main/frontend/main.css` untuk custom CSS
- Konfigurasi Tailwind di `src/main/frontend/tailwind.config.js`

### Content

- Update informasi rumah sakit di templates
- Modifikasi jadwal dokter di `schedule.html`
- Edit testimoni di `testimonial.html`

## 🔒 Security

- Pastikan password database tidak di-commit ke repository
- Gunakan environment variables untuk sensitive data
- Aktifkan HTTPS di production

## 📝 Development

### Hot Reload

```bash
# Terminal 1: Run Spring Boot
mvn spring-boot:run

# Terminal 2: Watch Tailwind CSS
cd src/main/frontend
npm run watch
```

### Database Migration

```bash
# Hibernate akan auto-create tables
# Migration untuk jadwal dokter: V1__init.sql, V2__add_reviews_table.sql
```

## 🚀 Deployment

### Production Build

```bash
mvn clean package
java -jar target/hospital-0.0.1-SNAPSHOT.jar
```

## 📞 Support

Untuk pertanyaan atau dukungan teknis:

- Email: tech@buahhatipamulang.co.id
- Phone: (021) 1234 5678

## 📄 License

Project ini dikembangkan untuk RSIA Buah Hati Pamulang. All rights reserved.

---

**RSIA Buah Hati Pamulang** - Pelayanan Kesehatan Modern & Terpercaya

# Railway Deployment (Nixpacks)

## Environment Variables

Atur di Railway dashboard (tab Variables):

| Key               | Value (contoh)                       | Keterangan               |
| ----------------- | ------------------------------------ | ------------------------ |
| DATABASE_URL      | jdbc:mysql://HOST:PORT/DATABASE_NAME | URL koneksi MySQL        |
| DATABASE_USERNAME | root                                 | Username MySQL           |
| DATABASE_PASSWORD | password                             | Password MySQL           |
| PORT              | 8080                                 | (Opsional, default 8080) |

Jika pakai Railway MySQL plugin, Railway akan otomatis mengisi variabel ini.

## Build & Start Command (Opsional)

Biasanya Railway auto-detect, tapi bisa diatur manual di tab Settings:

- Build Command:
  ```
  ./mvnw package -DskipTests
  ```
- Start Command:
  ```
  java -jar target/*.jar
  ```
