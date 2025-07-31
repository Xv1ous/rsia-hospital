# Database Schema Changes & Maintenance

## Overview
This document tracks all database schema changes and provides guidelines for maintaining the hospital application database.

## Schema Version History

### Version 1.0 - Initial Schema (V1__init.sql)
- **Date**: Initial
- **Description**: Creates basic tables for hospital management
- **Tables Created**:
  - `users` - User authentication and roles
  - `doctor` - Doctor information and status
  - `doctor_schedule` - Doctor availability schedules
  - `services` - Hospital services offered
  - `news` - News and announcements
  - `appointments` - Patient appointments

### Version 2.0 - Reviews System (V2__add_reviews_table.sql)
- **Date**: Added reviews functionality
- **Description**: Adds patient review system
- **Tables Created**:
  - `reviews` - Patient reviews and ratings

### Version 3.0 - Sample Data (V3__sample_data.sql)
- **Date**: Data population
- **Description**: Populates database with sample data
- **Data Added**:
  - 43 doctors from schedule data
  - 259 doctor schedules
  - 10 hospital services
  - 10 news articles
  - 10 sample appointments
  - 5 sample reviews
  - Admin user with encrypted password

### Version 4.0 - Data Cleanup & Performance (V4__cleanup_duplicate_doctors.sql)
- **Date**: Latest
- **Description**: Cleans up duplicate data and adds performance indexes
- **Changes**:
  - Removes duplicate doctor names
  - Normalizes data formatting
  - Adds database indexes for better performance

## Database Indexes

### Performance Indexes Added
```sql
-- Doctor Schedule Indexes
CREATE INDEX idx_doctor_schedule_name ON doctor_schedule(name);
CREATE INDEX idx_doctor_schedule_day ON doctor_schedule(day);

-- Appointment Indexes
CREATE INDEX idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);

-- Review Indexes
CREATE INDEX idx_reviews_doctor_id ON reviews(doctor_id);

-- News Indexes
CREATE INDEX idx_news_status ON news(status);
CREATE INDEX idx_news_date ON news(date);
```

## Foreign Key Relationships

### Current Relationships
1. **appointments.doctor_id** → **doctor.id** (ON DELETE SET NULL)
2. **reviews.doctor_id** → **doctor.id** (ON DELETE SET NULL)

### Notes
- Both foreign keys use `ON DELETE SET NULL` to prevent data loss
- If a doctor is deleted, their appointments and reviews remain but lose the doctor reference

## Data Maintenance Guidelines

### Regular Maintenance Tasks
1. **Backup Database**: Use `./scripts/simple/backup-db.sh`
2. **Check for Duplicates**: Monitor doctor_schedule for duplicate entries
3. **Verify Data Integrity**: Check foreign key relationships
4. **Monitor Performance**: Watch query performance with indexes

### Adding New Schema Changes
1. Create new migration file: `V5__description.sql`
2. Update this documentation
3. Test with `./scripts/simple/initialize-db.sh`
4. Update application entities if needed

### Security Considerations
- Admin passwords are encrypted using BCrypt
- Database credentials use environment variables
- Sensitive data should never be committed to version control

## Troubleshooting

### Common Issues
1. **Foreign Key Errors**: Check if referenced data exists
2. **Duplicate Data**: Run V4 cleanup script
3. **Performance Issues**: Verify indexes are created
4. **Connection Issues**: Check Docker container health

### Recovery Procedures
1. **Database Reset**: Use `./scripts/simple/initialize-db.sh`
2. **Backup Restore**: Use `./scripts/simple/mysql-access.sh` → Restore option
3. **Container Issues**: Restart with `docker-compose -f docker/docker-compose.dev.yml restart`

## Environment Variables

### Required Environment Variables
```bash
# Database
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_USER=hospital_user
MYSQL_PASSWORD=your_secure_hospital_password

# Admin
ADMIN_USERNAME=admin
ADMIN_PASSWORD=your_secure_admin_password

# Logging
LOGGING_LEVEL_ROOT=INFO
LOGGING_LEVEL_COM_EXAMPLE_HOSPITAL=DEBUG
LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_WEB=INFO
```

### Setup Instructions
1. Copy `config/env.example` to `.env`
2. Update values with secure passwords
3. Restart containers to apply changes
