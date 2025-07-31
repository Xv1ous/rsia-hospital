# RSIA Buah Hati Pamulang - API Documentation

## 📋 Overview

This document provides comprehensive API documentation for the RSIA Buah Hati Pamulang hospital management system. The API is built using Spring Boot and provides endpoints for managing doctors, appointments, users, and other hospital-related data.

## 🔗 Base URL

- **Development**: `http://localhost:8080`
- **Production**: `https://buahhatipamulang.co.id`

## 🔐 Authentication

The API uses Spring Security for authentication. Most endpoints require authentication except for public pages.

### Authentication Endpoints

#### Admin Login

```http
POST /admin/login
Content-Type: application/x-www-form-urlencoded

username=admin&password=password
```

**Response**:

```json
{
  "success": true,
  "redirectUrl": "/admin/dashboard"
}
```

#### Admin Logout

```http
POST /admin/logout
```

**Response**:

```json
{
  "success": true,
  "redirectUrl": "/"
}
```

## 👥 User Management

### Get All Users

```http
GET /api/users
Authorization: Bearer <token>
```

**Response**:

```json
{
  "users": [
    {
      "id": 1,
      "username": "john_doe",
      "email": "john@example.com",
      "role": "USER",
      "createdAt": "2024-01-15T10:30:00"
    }
  ]
}
```

### Create User

```http
POST /api/users
Content-Type: application/json
Authorization: Bearer <token>

{
  "username": "new_user",
  "email": "user@example.com",
  "password": "secure_password",
  "role": "USER"
}
```

### Update User

```http
PUT /api/users/{id}
Content-Type: application/json
Authorization: Bearer <token>

{
  "email": "updated@example.com",
  "role": "ADMIN"
}
```

### Delete User

```http
DELETE /api/users/{id}
Authorization: Bearer <token>
```

## 👨‍⚕️ Doctor Management

### Get All Doctors

```http
GET /api/doctors
```

**Response**:

```json
{
  "doctors": [
    {
      "id": 1,
      "name": "Dr. Sarah Johnson",
      "specialization": "Pediatrics",
      "image": "/images/doctors/dr-sarah.jpg",
      "description": "Experienced pediatrician with 15 years of practice"
    }
  ]
}
```

### Get Doctor by ID

```http
GET /api/doctors/{id}
```

**Response**:

```json
{
  "id": 1,
  "name": "Dr. Sarah Johnson",
  "specialization": "Pediatrics",
  "image": "/images/doctors/dr-sarah.jpg",
  "description": "Experienced pediatrician with 15 years of practice",
  "schedules": [
    {
      "id": 1,
      "day": "Monday",
      "time": "09:00 - 17:00",
      "status": "AVAILABLE"
    }
  ]
}
```

### Create Doctor

```http
POST /api/doctors
Content-Type: application/json
Authorization: Bearer <token>

{
  "name": "Dr. Michael Chen",
  "specialization": "Cardiology",
  "description": "Cardiologist specializing in heart disease",
  "image": "/images/doctors/dr-michael.jpg"
}
```

### Update Doctor

```http
PUT /api/doctors/{id}
Content-Type: application/json
Authorization: Bearer <token>

{
  "name": "Dr. Sarah Johnson-Smith",
  "specialization": "Pediatrics",
  "description": "Updated description"
}
```

### Delete Doctor

```http
DELETE /api/doctors/{id}
Authorization: Bearer <token>
```

## 📅 Schedule Management

### Get Doctor Schedules

```http
GET /api/schedules
```

**Query Parameters**:

- `specialization` (optional): Filter by doctor specialization
- `day` (optional): Filter by day of week

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

### Get Schedules by Doctor

```http
GET /api/doctors/{doctorId}/schedules
```

### Create Schedule

```http
POST /api/schedules
Content-Type: application/json
Authorization: Bearer <token>

{
  "doctorId": 1,
  "day": "Tuesday",
  "time": "10:00 - 18:00",
  "status": "AVAILABLE"
}
```

### Update Schedule

```http
PUT /api/schedules/{id}
Content-Type: application/json
Authorization: Bearer <token>

{
  "time": "11:00 - 19:00",
  "status": "UNAVAILABLE"
}
```

### Delete Schedule

```http
DELETE /api/schedules/{id}
Authorization: Bearer <token>
```

## 📋 Appointment Management

### Get All Appointments

```http
GET /api/appointments
Authorization: Bearer <token>
```

**Query Parameters**:

- `status` (optional): Filter by appointment status
- `doctorId` (optional): Filter by doctor
- `userId` (optional): Filter by user

**Response**:

```json
{
  "appointments": [
    {
      "id": 1,
      "user": {
        "id": 1,
        "username": "john_doe"
      },
      "doctor": {
        "id": 1,
        "name": "Dr. Sarah Johnson"
      },
      "appointmentDate": "2024-01-20T14:00:00",
      "status": "CONFIRMED",
      "notes": "Regular checkup"
    }
  ]
}
```

### Get Appointment by ID

```http
GET /api/appointments/{id}
Authorization: Bearer <token>
```

### Create Appointment

```http
POST /api/appointments
Content-Type: application/json
Authorization: Bearer <token>

{
  "doctorId": 1,
  "appointmentDate": "2024-01-25T10:00:00",
  "notes": "Annual physical examination"
}
```

### Update Appointment Status

```http
PUT /api/appointments/{id}/status
Content-Type: application/json
Authorization: Bearer <token>

{
  "status": "CONFIRMED"
}
```

### Cancel Appointment

```http
PUT /api/appointments/{id}/cancel
Authorization: Bearer <token>
```

### Delete Appointment

```http
DELETE /api/appointments/{id}
Authorization: Bearer <token>
```

## 🏥 Service Management

### Get All Services

```http
GET /api/services
```

**Response**:

```json
{
  "services": [
    {
      "id": 1,
      "name": "General Consultation",
      "description": "Comprehensive health consultation",
      "icon": "fa-user-md"
    }
  ]
}
```

### Create Service

```http
POST /api/services
Content-Type: application/json
Authorization: Bearer <token>

{
  "name": "Emergency Care",
  "description": "24/7 emergency medical services",
  "icon": "fa-ambulance"
}
```

### Update Service

```http
PUT /api/services/{id}
Content-Type: application/json
Authorization: Bearer <token>

{
  "name": "Updated Service Name",
  "description": "Updated description"
}
```

### Delete Service

```http
DELETE /api/services/{id}
Authorization: Bearer <token>
```

## 📰 News Management

### Get All News

```http
GET /api/news
```

**Query Parameters**:

- `limit` (optional): Number of news items to return
- `page` (optional): Page number for pagination

**Response**:

```json
{
  "news": [
    {
      "id": 1,
      "title": "New Pediatric Wing Opening",
      "content": "We are excited to announce the opening of our new pediatric wing...",
      "image": "/images/news/pediatric-wing.jpg",
      "publishedAt": "2024-01-15T09:00:00",
      "author": "Hospital Admin"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 25
  }
}
```

### Get News by ID

```http
GET /api/news/{id}
```

### Create News

```http
POST /api/news
Content-Type: application/json
Authorization: Bearer <token>

{
  "title": "New Medical Equipment Arrival",
  "content": "We have received state-of-the-art medical equipment...",
  "image": "/images/news/equipment.jpg",
  "author": "Hospital Admin"
}
```

### Update News

```http
PUT /api/news/{id}
Content-Type: application/json
Authorization: Bearer <token>

{
  "title": "Updated News Title",
  "content": "Updated content..."
}
```

### Delete News

```http
DELETE /api/news/{id}
Authorization: Bearer <token>
```

## 📊 Statistics & Analytics

### Get Dashboard Statistics

```http
GET /api/admin/statistics
Authorization: Bearer <token>
```

**Response**:

```json
{
  "totalPatients": 1250,
  "totalDoctors": 15,
  "totalAppointments": 89,
  "pendingAppointments": 12,
  "confirmedAppointments": 67,
  "cancelledAppointments": 10,
  "revenue": {
    "monthly": 15000000,
    "yearly": 180000000
  }
}
```

### Get Appointment Statistics

```http
GET /api/admin/appointments/statistics
Authorization: Bearer <token>
```

**Query Parameters**:

- `period` (optional): daily, weekly, monthly, yearly

**Response**:

```json
{
  "period": "monthly",
  "data": [
    {
      "date": "2024-01-01",
      "appointments": 15,
      "confirmed": 12,
      "cancelled": 3
    }
  ]
}
```

## 🔍 Search & Filter

### Search Doctors

```http
GET /api/doctors/search
```

**Query Parameters**:

- `q` (required): Search query
- `specialization` (optional): Filter by specialization

**Response**:

```json
{
  "doctors": [
    {
      "id": 1,
      "name": "Dr. Sarah Johnson",
      "specialization": "Pediatrics",
      "matchScore": 0.95
    }
  ]
}
```

### Search Appointments

```http
GET /api/appointments/search
Authorization: Bearer <token>
```

**Query Parameters**:

- `q` (required): Search query (patient name, doctor name)
- `dateFrom` (optional): Start date
- `dateTo` (optional): End date

## 📁 File Upload

### Upload Doctor Image

```http
POST /api/upload/doctor-image
Content-Type: multipart/form-data
Authorization: Bearer <token>

file: [binary file data]
```

**Response**:

```json
{
  "success": true,
  "filename": "dr-sarah-johnson-20240115.jpg",
  "url": "/images/doctors/dr-sarah-johnson-20240115.jpg"
}
```

### Upload News Image

```http
POST /api/upload/news-image
Content-Type: multipart/form-data
Authorization: Bearer <token>

file: [binary file data]
```

## ⚠️ Error Handling

### Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Email format is invalid"
      }
    ],
    "timestamp": "2024-01-15T10:30:00"
  }
}
```

### Common Error Codes

| Code               | Description              | HTTP Status |
| ------------------ | ------------------------ | ----------- |
| `VALIDATION_ERROR` | Input validation failed  | 400         |
| `UNAUTHORIZED`     | Authentication required  | 401         |
| `FORBIDDEN`        | Insufficient permissions | 403         |
| `NOT_FOUND`        | Resource not found       | 404         |
| `CONFLICT`         | Resource conflict        | 409         |
| `INTERNAL_ERROR`   | Server error             | 500         |

### Example Error Responses

#### Validation Error

```http
POST /api/doctors
Content-Type: application/json

{
  "name": "",
  "specialization": "invalid"
}
```

**Response** (400):

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "name",
        "message": "Name is required"
      },
      {
        "field": "specialization",
        "message": "Invalid specialization"
      }
    ]
  }
}
```

#### Not Found Error

```http
GET /api/doctors/999
```

**Response** (404):

```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Doctor with ID 999 not found"
  }
}
```

## 📝 Rate Limiting

The API implements rate limiting to prevent abuse:

- **Public endpoints**: 100 requests per minute
- **Authenticated endpoints**: 1000 requests per minute
- **Admin endpoints**: 5000 requests per minute

### Rate Limit Headers

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1642234567
```

## 🔄 Pagination

Endpoints that return lists support pagination:

### Pagination Parameters

- `page` (optional): Page number (default: 1)
- `size` (optional): Items per page (default: 20, max: 100)

### Pagination Response

```json
{
  "data": [...],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 100,
    "hasNext": true,
    "hasPrevious": false
  }
}
```

## 📋 API Versioning

The API uses URL versioning:

- **Current version**: `/api/v1/`
- **Future versions**: `/api/v2/`, `/api/v3/`, etc.

## 🔧 Testing

### Test Endpoints

#### Health Check

```http
GET /actuator/health
```

**Response**:

```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP"
    },
    "diskSpace": {
      "status": "UP"
    }
  }
}
```

#### API Info

```http
GET /actuator/info
```

**Response**:

```json
{
  "app": {
    "name": "RSIA Buah Hati Pamulang",
    "version": "1.0.0",
    "description": "Hospital Management System"
  }
}
```

## 📚 SDK & Examples

### cURL Examples

#### Create Appointment

```bash
curl -X POST http://localhost:8080/api/appointments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "doctorId": 1,
    "appointmentDate": "2024-01-25T10:00:00",
    "notes": "Regular checkup"
  }'
```

#### Get Doctor Schedules

```bash
curl -X GET "http://localhost:8080/api/schedules?specialization=Pediatrics" \
  -H "Accept: application/json"
```

### JavaScript Examples

#### Fetch Doctors

```javascript
async function getDoctors() {
  const response = await fetch("/api/doctors");
  const data = await response.json();
  return data.doctors;
}
```

#### Create Appointment

```javascript
async function createAppointment(appointmentData) {
  const response = await fetch("/api/appointments", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(appointmentData),
  });

  if (!response.ok) {
    throw new Error("Failed to create appointment");
  }

  return response.json();
}
```

## 📞 Support

For API support and questions:

- **Email**: api-support@buahhatipamulang.co.id
- **Documentation**: https://docs.buahhatipamulang.co.id/api
- **Status Page**: https://status.buahhatipamulang.co.id

---

**Version**: 1.0.0
**Last Updated**: January 2024
**API Version**: v1
