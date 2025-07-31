# RSIA Buah Hati Pamulang - System Documentation

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Technology Stack](#technology-stack)
4. [Database Design](#database-design)
5. [API Documentation](#api-documentation)
6. [Frontend Documentation](#frontend-documentation)
7. [Installation Guide](#installation-guide)
8. [Development Guide](#development-guide)
9. [Deployment Guide](#deployment-guide)
10. [Security Considerations](#security-considerations)
11. [Troubleshooting](#troubleshooting)

---

## 🏥 Project Overview

**RSIA Buah Hati Pamulang** adalah sistem manajemen rumah sakit yang dibangun untuk memberikan layanan informasi kesehatan modern dan terpercaya. Sistem ini memungkinkan pasien untuk mengakses informasi layanan, jadwal dokter, dan melakukan janji temu secara online.

### Fitur Utama

- **Landing Page Modern** dengan desain responsif
- **Manajemen Jadwal Dokter** dengan filter berdasarkan spesialisasi
- **Sistem Janji Temu** untuk pasien
- **Informasi Layanan** rumah sakit
- **Testimoni Pasien** untuk membangun kepercayaan
- **Panel Admin** untuk manajemen konten
- **Sistem Berita** dan informasi terbaru
- **Kontak & Lokasi** dengan integrasi peta

---

## 🏗️ System Architecture

### High-Level Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   (Thymeleaf)   │◄──►│   (Spring Boot) │◄──►│   (MySQL)       │
│   + Tailwind    │    │   + JPA         │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Component Architecture

```
src/main/
├── java/com/example/hospital/
│   ├── controller/          # REST Controllers & Web Controllers
│   ├── entity/              # JPA Entities
│   ├── repository/          # Data Access Layer
│   ├── SecurityConfig.java  # Security Configuration
│   └── HospitalApplication.java
├── resources/
│   ├── templates/           # Thymeleaf templates
│   │   ├── fragments/       # Reusable components
│   │   ├── admin/           # Admin pages
│   │   └── user/            # User pages
│   ├── static/              # Static assets
│   └── application.properties
└── frontend/                # Tailwind CSS source
```

---

## 🛠️ Technology Stack

### Backend Technologies

- **Java 21** - Programming language
- **Spring Boot 3.5.3** - Application framework
- **Spring Data JPA** - Object-relational mapping
- **Spring Security** - Authentication & authorization
- **Spring Cloud OpenFeign** - HTTP client
- **MySQL 8.0** - Database
- **Thymeleaf** - Template engine
- **Lombok** - Boilerplate code reduction

### Frontend Technologies

- **HTML5** - Markup language
- **Tailwind CSS** - Utility-first CSS framework
- **JavaScript (Vanilla)** - Client-side interactivity
- **Responsive Design** - Mobile-first approach

### Development Tools

- **Maven** - Build tool
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Node.js** - Frontend build tool
- **Nginx** - Reverse proxy (optional)

---

## 🗄️ Database Design

### Entity Relationships

#### Core Entities

**1. User Entity**

```java
@Entity
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String username;
    private String password;
    private String email;
    private String role; // ADMIN, USER
    private LocalDateTime createdAt;
}
```

**2. Doctor Entity**

```java
@Entity
public class Doctor {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String specialization;
    private String image;
    private String description;
}
```

**3. DoctorSchedule Entity**

```java
@Entity
public class DoctorSchedule {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    private Doctor doctor;
    private String day;
    private String time;
    private String status; // AVAILABLE, UNAVAILABLE
}
```

**4. Appointment Entity**

```java
@Entity
public class Appointment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    private User user;
    @ManyToOne
    private Doctor doctor;
    private LocalDateTime appointmentDate;
    private String status; // PENDING, CONFIRMED, CANCELLED
    private String notes;
}
```

**5. Service Entity**

```java
@Entity
public class Service {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String description;
    private String icon;
}
```

**6. News Entity**

```java
@Entity
public class News {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    private String content;
    private String image;
    private LocalDateTime publishedAt;
    private String author;
}
```

### Database Schema

```sql
-- Users table
CREATE TABLE user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    role VARCHAR(50) DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors table
CREATE TABLE doctor (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialization VARCHAR(255),
    image VARCHAR(500),
    description TEXT
);

-- Doctor schedules table
CREATE TABLE doctor_schedule (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    doctor_id BIGINT,
    day VARCHAR(50),
    time VARCHAR(100),
    status VARCHAR(50) DEFAULT 'AVAILABLE',
    FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);

-- Appointments table
CREATE TABLE appointment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    doctor_id BIGINT,
    appointment_date TIMESTAMP,
    status VARCHAR(50) DEFAULT 'PENDING',
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);

-- Services table
CREATE TABLE service (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    icon VARCHAR(255)
);

-- News table
CREATE TABLE news (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    image VARCHAR(500),
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    author VARCHAR(255)
);
```

---

## 🔌 API Documentation

### Controllers Overview

#### 1. HomeController

**Purpose**: Handles main website pages and user-facing functionality

**Key Endpoints**:

- `GET /` - Home page
- `GET /about` - About page
- `GET /services` - Services page
- `GET /doctors` - Doctors listing
- `GET /schedule` - Doctor schedules
- `GET /appointments` - Appointment management
- `GET /news` - News listing

#### 2. AdminController

**Purpose**: Handles admin authentication and dashboard

**Key Endpoints**:

- `GET /admin/login` - Admin login page
- `POST /admin/login` - Admin authentication
- `GET /admin/dashboard` - Admin dashboard
- `POST /admin/logout` - Admin logout

#### 3. AdminPageController

**Purpose**: Handles admin CRUD operations

**Key Endpoints**:

- `GET /admin/doctors` - Doctor management
- `POST /admin/doctors` - Create/update doctor
- `DELETE /admin/doctors/{id}` - Delete doctor
- `GET /admin/appointments` - Appointment management
- `GET /admin/news` - News management

### Request/Response Examples

#### Get Doctor Schedule

```http
GET /api/schedule?specialization=Pediatrics
```

**Response**:

```json
{
  "schedules": [
    {
      "id": 1,
      "doctor": {
        "id": 1,
        "name": "Dr. Sarah Johnson",
        "specialization": "Pediatrics"
      },
      "day": "Monday",
      "time": "09:00 - 17:00",
      "status": "AVAILABLE"
    }
  ]
}
```

#### Create Appointment

```http
POST /api/appointments
Content-Type: application/json

{
  "doctorId": 1,
  "appointmentDate": "2024-01-15T10:00:00",
  "notes": "Regular checkup"
}
```

---

## 🎨 Frontend Documentation

### Template Structure

#### Layout Components

- `fragments/head.html` - Common head section
- `fragments/navbar.html` - Navigation bar
- `fragments/footer.html` - Footer section

#### Page Templates

- `index.html` - Home page
- `user/` - User-facing pages
- `admin/` - Admin panel pages
- `error/` - Error pages

#### Reusable Fragments

- `fragments/hero.html` - Hero section
- `fragments/schedule.html` - Doctor schedule component
- `fragments/testimonial.html` - Testimonials
- `fragments/news.html` - News listing

### Styling System

#### Tailwind CSS Configuration

```javascript
// tailwind.config.js
module.exports = {
  content: [
    "./src/main/resources/templates/**/*.html",
    "./src/main/frontend/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#2563eb",
        secondary: "#64748b",
      },
    },
  },
};
```

#### Custom CSS Classes

```css
/* main.css */
.hospital-gradient {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.card-hover {
  transition: transform 0.3s ease;
}

.card-hover:hover {
  transform: translateY(-5px);
}
```

### JavaScript Functionality

#### Schedule Filtering

```javascript
function filterSchedule(specialization) {
  const schedules = document.querySelectorAll(".schedule-item");
  schedules.forEach((item) => {
    if (
      specialization === "all" ||
      item.dataset.specialization === specialization
    ) {
      item.style.display = "block";
    } else {
      item.style.display = "none";
    }
  });
}
```

#### Appointment Booking

```javascript
function bookAppointment(doctorId, date) {
  fetch("/api/appointments", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      doctorId: doctorId,
      appointmentDate: date,
    }),
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        showNotification("Appointment booked successfully!", "success");
      }
    });
}
```

---

## 📦 Installation Guide

### Prerequisites

- Java 21 or higher
- Maven 3.6+
- MySQL 8.0+
- Node.js 18+ (for Tailwind CSS)
- Docker & Docker Compose (optional)

### Step-by-Step Installation

#### 1. Clone Repository

```bash
git clone <repository-url>
cd hospital
```

#### 2. Database Setup

```bash
# Create database
mysql -u root -p -e "CREATE DATABASE hospital;"

# Or use Docker
docker-compose up mysql -d
```

#### 3. Configuration

```bash
# Copy environment file
cp env.example .env

# Edit application.properties
nano src/main/resources/application.properties
```

#### 4. Install Dependencies

```bash
# Install Java dependencies
mvn dependency:resolve

# Install frontend dependencies
cd src/main/frontend
npm install
cd ../..
```

#### 5. Build Application

```bash
# Build entire application
mvn clean compile

# Or use Makefile
make build
```

#### 6. Run Application

```bash
# Development mode
mvn spring-boot:run

# Or use Makefile
make run
```

### Quick Start with Docker

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f app
```

---

## 🚀 Development Guide

### Development Environment Setup

#### 1. IDE Configuration

- **IntelliJ IDEA**: Import as Maven project
- **Eclipse**: Import existing Maven project
- **VS Code**: Install Java and Spring Boot extensions

#### 2. Hot Reload Setup

```bash
# Terminal 1: Run Spring Boot
mvn spring-boot:run

# Terminal 2: Watch Tailwind CSS
cd src/main/frontend
npm run watch
```

#### 3. Database Development

```bash
# Reset database
make db-reset

# View database
mysql -u root -p hospital
```

### Code Organization

#### Package Structure

```
com.example.hospital/
├── controller/          # Web controllers
│   ├── HomeController.java
│   ├── AdminController.java
│   └── AdminPageController.java
├── entity/              # JPA entities
│   ├── User.java
│   ├── Doctor.java
│   ├── Appointment.java
│   └── ...
├── repository/          # Data access
│   ├── UserRepository.java
│   ├── DoctorRepository.java
│   └── ...
└── SecurityConfig.java  # Security configuration
```

#### Naming Conventions

- **Controllers**: `*Controller.java`
- **Entities**: PascalCase (e.g., `Doctor.java`)
- **Repositories**: `*Repository.java`
- **Templates**: kebab-case (e.g., `doctor-profile.html`)

### Testing

#### Unit Tests

```bash
# Run all tests
mvn test

# Run specific test
mvn test -Dtest=HomeControllerTest
```

#### Integration Tests

```bash
# Run with test profile
mvn test -Dspring.profiles.active=test
```

### Code Quality

#### Maven Commands

```bash
# Check code style
mvn checkstyle:check

# Run static analysis
mvn spotbugs:check

# Generate reports
mvn site
```

---

## 🚀 Deployment Guide

### Production Environment

#### 1. Environment Variables

```bash
# Database
DB_HOST=your-db-host
DB_PORT=3306
DB_NAME=hospital
DB_USERNAME=hospital_user
DB_PASSWORD=secure_password

# Application
SERVER_PORT=8080
SPRING_PROFILES_ACTIVE=prod
```

#### 2. Production Build

```bash
# Build JAR file
mvn clean package -DskipTests

# Verify JAR
java -jar target/hospital-0.0.1-SNAPSHOT.jar --version
```

#### 3. Docker Deployment

```bash
# Build image
docker build -t rsia-buah-hati-pamulang .

# Run container
docker run -d \
  --name hospital-app \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  rsia-buah-hati-pamulang
```

#### 4. Docker Compose Production

```bash
# Start production stack
docker-compose -f docker-compose.prod.yml up -d

# Monitor logs
docker-compose logs -f
```

### Nginx Configuration

#### Reverse Proxy Setup

```nginx
server {
    listen 80;
    server_name buahhatipamulang.co.id;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static/ {
        alias /var/www/hospital/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### SSL/HTTPS Setup

#### Let's Encrypt Configuration

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Obtain certificate
sudo certbot --nginx -d buahhatipamulang.co.id

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### Monitoring & Logging

#### Application Monitoring

```bash
# Health check endpoint
curl http://localhost:8080/actuator/health

# Metrics endpoint
curl http://localhost:8080/actuator/metrics
```

#### Log Management

```bash
# View application logs
tail -f logs/hospital.log

# Log rotation
logrotate /etc/logrotate.d/hospital
```

---

## 🔒 Security Considerations

### Authentication & Authorization

#### User Roles

- **ADMIN**: Full access to admin panel
- **USER**: Access to appointment booking and user features

#### Security Configuration

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/**").authenticated()
                .anyRequest().permitAll()
            )
            .formLogin(form -> form
                .loginPage("/admin/login")
                .defaultSuccessUrl("/admin/dashboard")
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/")
            );
        return http.build();
    }
}
```

### Data Protection

#### Password Security

- Passwords are encrypted using BCrypt
- Minimum password requirements enforced
- Password reset functionality available

#### Input Validation

- Server-side validation for all inputs
- SQL injection prevention through JPA
- XSS protection through Thymeleaf

### Environment Security

#### Configuration Management

```bash
# Use environment variables for sensitive data
export DB_PASSWORD=secure_password
export JWT_SECRET=your_jwt_secret

# Never commit sensitive data to version control
echo "*.env" >> .gitignore
```

#### Database Security

```sql
-- Create dedicated database user
CREATE USER 'hospital_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON hospital.* TO 'hospital_user'@'localhost';
FLUSH PRIVILEGES;
```

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Database Connection Issues

```bash
# Check MySQL status
sudo systemctl status mysql

# Test connection
mysql -u root -p -e "SELECT 1;"

# Check application logs
tail -f logs/spring.log
```

#### 2. Port Already in Use

```bash
# Find process using port 8080
lsof -i :8080

# Kill process
kill -9 <PID>

# Or change port in application.properties
server.port=8081
```

#### 3. Frontend Build Issues

```bash
# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Check Node.js version
node --version  # Should be 18+
```

#### 4. Docker Issues

```bash
# Clean Docker resources
docker system prune -a

# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Performance Optimization

#### Database Optimization

```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_doctor_specialization ON doctor(specialization);
CREATE INDEX idx_appointment_date ON appointment(appointment_date);
CREATE INDEX idx_news_published ON news(published_at);
```

#### Application Optimization

```properties
# application.properties
# Enable connection pooling
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5

# Enable caching
spring.cache.type=caffeine
spring.cache.cache-names=doctors,schedules,news
```

### Monitoring & Debugging

#### Health Checks

```bash
# Application health
curl http://localhost:8080/actuator/health

# Database health
curl http://localhost:8080/actuator/health/db

# Disk space
curl http://localhost:8080/actuator/health/diskSpace
```

#### Log Analysis

```bash
# Search for errors
grep "ERROR" logs/hospital.log

# Monitor real-time logs
tail -f logs/hospital.log | grep -E "(ERROR|WARN)"

# Analyze slow queries
grep "slow query" logs/hospital.log
```

---

## 📞 Support & Maintenance

### Contact Information

- **Technical Support**: tech@buahhatipamulang.co.id
- **Emergency**: (021) 1234 5678
- **Documentation**: https://docs.buahhatipamulang.co.id

### Maintenance Schedule

- **Daily**: Database backups
- **Weekly**: Log rotation and cleanup
- **Monthly**: Security updates and patches
- **Quarterly**: Performance review and optimization

### Backup Procedures

```bash
# Database backup
mysqldump -u root -p hospital > backup_$(date +%Y%m%d).sql

# Application backup
tar -czf hospital_backup_$(date +%Y%m%d).tar.gz \
    --exclude=target \
    --exclude=node_modules \
    .
```

---

## 📄 License & Legal

This project is developed for RSIA Buah Hati Pamulang. All rights reserved.

**Version**: 1.0.0
**Last Updated**: January 2024
**Maintainer**: Development Team
**License**: Proprietary - RSIA Buah Hati Pamulang

---

_This documentation is maintained by the development team. For questions or updates, please contact the technical support team._
