# Database Initialization Guide

## Overview

The Hospital Management System now includes automatic database initialization with real doctor schedule data from RSIA Buah Hati Pamulang. This feature allows you to quickly set up a fully functional database with sample data without manual input.

## What's Included

When you initialize the database, the following data will be automatically loaded:

### 🏥 Real Doctor Schedules

- **Spesialis Kebidanan & Kandungan**: dr. Irwan Eka Putra, Sp.OG, dr. Medissa Diantika, Sp.OG, dr. E. Rohati, Sp.OG, dr. Ismail Yahya, Sp.OG
- **Spesialis Anak**: dr. Ellya Marliah, Sp.A, dr. Fajar Subroto, Sp.A (K), dr. Firmansyah Chatab, Sp.A, dr. Hetty Wati Napitupulu, Sp.A, dr. Labiqotullababah Ahasmi, Sp.A, dr. Fitriyani, Sp.A
- **Subspesialis Endokrinologi**: dr. Aditya Suryansyah, Sp.A (K), dr. Endang Triningsih, Sp.A (K)
- **Spesialis THT**: dr. Sandhi Ari Susanti Sp.THT-KL
- **Spesialis Bedah**: dr. M. Reza Jauhari Zen, Sp.B, dr. R. Diky Laksmana, Sp.B,FICS
- **Dokter Gigi**: drg. Bono Widiastuti, Sp. KGA, drg. Rini Triani, Sp. KGA, drg. Murni, drg. Nastiti Rahajeng, drg. Riani Apsari, drg. Cicilia Triana, drg. Syleovina Rizkita Sari, drg. Laksmi Kusumaningtyas
- **Dokter Umum**: dr. Sekar Asmara Jayaning Diah, dr. Ning Indah Permatasari, dr. Amalina Fitrasari, dr. Reza Hafiyyan
- **Poli Laktasi**: dr. Shella Riana, dr. Sarah Kamilah
- **Radiologi**: dr. Sri Dewi Imayanti, Sp.Rad
- **Spesialis Penyakit Dalam**: dr. Ryandri Yovanda, Sp.PD
- **Dokter IGD**: dr. Radia Puri, dr. Nabila Maudy Salma, dr. Amalina Fitrasari, dr. Taqiyya Maryam, dr. Ning Indah Permatasari, dr. Saflan Ady Saputra, dr. Reza Hafiyyan, dr. Khusnul Khotimah
- **Spesialis Rehabilitasi Medik**: dr. Hikmah Amayanti Adil, Sp.KFR
- **Poliklinik Nyeri**: dr. Rika Ilham Munazat, Sp.An
- **Tumbuh Kembang**: Susilawaty, SST.Ft

### 📋 Sample Services

- Konsultasi Umum
- Pemeriksaan Laboratorium
- Radiologi
- Farmasi
- Gawat Darurat
- Rawat Inap
- Fisioterapi
- Konsultasi Gizi
- Vaksinasi
- Kesehatan Gigi

### 📰 Sample News Articles

- 10 sample news articles about hospital services and health tips

### 📅 Sample Appointments

- 10 sample patient appointments with various doctors

### 👤 Admin User

- Username: `admin`
- Password: Encrypted value (as provided)

## How to Initialize Database

### Option 1: Using Quick Access Menu

#### Linux/Mac:

```bash
./quick-access.sh
# Choose option 6: Initialize Database
```

#### Windows:

```cmd
QUICK_ACCESS.bat
# Choose option 6: Initialize Database
```

### Option 2: Direct Script Execution

#### Linux/Mac:

```bash
./scripts/simple/initialize-db.sh
```

#### Windows:

```cmd
scripts\simple\INITIALIZE-DB.bat
```

## What Happens During Initialization

1. **Warning**: You'll see a warning that all existing data will be lost
2. **Confirmation**: Type 'yes' to proceed
3. **Container Stop**: Existing containers are stopped
4. **Volume Removal**: Database volume is removed to ensure clean state
5. **Container Start**: Containers are started with fresh database
6. **Wait Time**: 30-second wait for database to be ready
7. **Verification**: Sample data is displayed to confirm successful initialization

## After Initialization

Once initialization is complete, you can:

- **Access the application**: http://localhost:8080
- **Login as admin**: Use the admin credentials
- **View doctor schedules**: All real doctor schedules from RSIA Buah Hati Pamulang
- **Make appointments**: Test the appointment booking system
- **View news**: Browse sample news articles
- **Explore services**: Check out the available medical services

## Important Notes

⚠️ **Warning**: This process will completely reset your database and remove all existing data.

✅ **Safe to use**: The initialization uses the same data structure as the production system.

🔄 **Repeatable**: You can run this initialization multiple times to reset the database.

📊 **Real Data**: The doctor schedules are based on actual data from RSIA Buah Hati Pamulang.

## Troubleshooting

### If initialization fails:

1. **Check Docker**: Ensure Docker is running
2. **Check ports**: Make sure ports 8080 and 3306 are available
3. **Check permissions**: Ensure scripts have execute permissions
4. **Check logs**: View container logs for error details

### If data doesn't appear:

1. **Wait longer**: Database might need more time to initialize
2. **Check migration**: Ensure V3\_\_sample_data.sql is in the migration folder
3. **Restart application**: Try stopping and starting the application again

## Migration Files

The initialization uses these migration files:

- `V1__init.sql`: Creates database schema
- `V2__add_reviews_table.sql`: Adds reviews table
- `V3__sample_data.sql`: Loads sample data

## Support

If you encounter any issues with database initialization, please check the logs or contact the development team.
