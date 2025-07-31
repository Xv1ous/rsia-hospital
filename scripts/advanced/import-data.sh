#!/bin/bash

# Import Data Script untuk RSIA Buah Hati Pamulang
# Usage: ./scripts/import-data.sh

set -e

# Colors untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function untuk print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function untuk check if containers are running
check_containers() {
    print_status "Checking if containers are running..."

    if ! sudo docker ps | grep -q "hospital-mysql-dev"; then
        print_error "MySQL container is not running. Please start the containers first."
        exit 1
    fi

    if ! sudo docker ps | grep -q "hospital-app-dev"; then
        print_error "Application container is not running. Please start the containers first."
        exit 1
    fi

    print_success "Containers are running"
}

# Function untuk import basic data
import_basic_data() {
    print_status "Importing basic data..."

    # Import doctor schedule data
    print_status "Importing doctor schedule data..."
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
INSERT INTO doctor_schedule(hospital, name, day, time, specialization) VALUES
('Rumah Sakit Buah Hati Pamulang', 'dr. Irwan Eka Putra, Sp.OG', 'Senin', '14:00-17:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Irwan Eka Putra, Sp.OG', 'Minggu', '09:00-12:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Medissa Diantika, Sp.OG', 'Selasa', '14:00-16:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Medissa Diantika, Sp.OG', 'Jumat', '13:00-15:30', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Senin', '09:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Selasa', '09:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Kamis', '15:00-18:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Jumat', '16:00-18:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Sabtu', '09:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Senin', '19:30-21:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Selasa', '18:00-Selesai', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Rabu', '13:00-17:30', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Kamis', '10:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Jumat', '09:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Jumat', '18:00-Selesai', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Sabtu', '18:00-Selesai', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Senin', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Selasa', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Rabu', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Kamis', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Jumat', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Senin', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Selasa', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Rabu', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Kamis', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Jumat', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Sabtu', '12:00-16:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Minggu', '10:00-13:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sandhi Ari Susanti Sp.THT-KL', 'Senin', '13:00-15:00', 'Spesialis THT'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sandhi Ari Susanti Sp.THT-KL', 'Kamis', '15:00-17:00', 'Spesialis THT'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sandhi Ari Susanti Sp.THT-KL', 'Sabtu', '12:00-15:00', 'Spesialis THT'),
('Rumah Sakit Buah Hati Pamulang', 'dr. M. Reza Jauhari Zen, Sp.B', 'Rabu', '14:00-17:00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS', 'Senin', '12:00-14:00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS', 'Selasa', '19:00-21:00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS', 'Rabu', '12:00-14:00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS', 'Kamis', '19:00-21:00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS', 'Jumat', '19:00-21:00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Bono Widiastuti, Sp. KGA', 'Rabu', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Bono Widiastuti, Sp. KGA', 'Jumat', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Rini Triani, Sp. KGA', 'Selasa', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Rini Triani, Sp. KGA', 'Kamis', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Murni', 'Senin', '16:00-19:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Murni', 'Sabtu', '13:00-16:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Nastiti Rahajeng', 'Selasa', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Nastiti Rahajeng', 'Jumat', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Riani Apsari', 'Rabu', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Riani Apsari', 'Jumat', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Cicilia Triana', 'Senin', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Cicilia Triana', 'Kamis', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Cicilia Triana', 'Jumat', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Syleovina Rizkita Sari', 'Rabu', '13:00-16:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Syleovina Rizkita Sari', 'Kamis', '13:00-16:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Laksmi Kusumaningtyas', 'Selasa', '13:00-16:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Laksmi Kusumaningtyas', 'Minggu', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Senin', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Selasa', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Rabu', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Kamis', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Jumat', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Senin', '12:00-16:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Selasa', '12:00-16:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Rabu', '12:00-16:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Kamis', '12:00-16:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Jumat', '12:00-16:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Amalina Fitrasari', 'Selasa', '18:00-20:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Amalina Fitrasari', 'Rabu', '18:00-20:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Amalina Fitrasari', 'Kamis', '18:00-20:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Reza Hafiyyan', 'Sabtu', '08:00-16:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Reza Hafiyyan', 'Minggu', '08:00-16:00', 'Dokter Umum');
EOF

    print_success "Doctor schedule data imported"

    # Import doctor data from schedule
    print_status "Importing doctor data..."
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
INSERT INTO doctor (name, specialization)
SELECT DISTINCT name, specialization FROM doctor_schedule;
EOF

    print_success "Doctor data imported"
}

# Function untuk import sample services
import_services() {
    print_status "Importing sample services..."

    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
INSERT INTO services (name, description, category) VALUES
('Poli Umum', 'Layanan pemeriksaan kesehatan umum', 'Poliklinik'),
('Poli Gigi', 'Layanan kesehatan gigi dan mulut', 'Poliklinik'),
('Poli Anak', 'Layanan kesehatan khusus anak', 'Poliklinik'),
('Poli Kandungan', 'Layanan kesehatan ibu hamil dan kandungan', 'Poliklinik'),
('Poli Bedah', 'Layanan operasi dan pembedahan', 'Poliklinik'),
('IGD', 'Instalasi Gawat Darurat 24 jam', 'Emergency'),
('Radiologi', 'Layanan pemeriksaan radiologi', 'Diagnostik'),
('Laboratorium', 'Layanan pemeriksaan laboratorium', 'Diagnostik'),
('Farmasi', 'Layanan obat dan apotek', 'Support'),
('Rawat Inap', 'Layanan rawat inap pasien', 'Inpatient');
EOF

    print_success "Services data imported"
}

# Function untuk import sample news
import_news() {
    print_status "Importing sample news..."

    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
INSERT INTO news (title, content, image_url, date, status) VALUES
('RSIA Buah Hati Pamulang Buka Layanan 24 Jam', 'RSIA Buah Hati Pamulang kini melayani pasien 24 jam untuk memberikan pelayanan kesehatan terbaik.', '/asset hospital/RSIA_BHP_LOGO5.png', CURDATE(), 'PUBLISHED'),
('Tips Kesehatan untuk Ibu Hamil', 'Artikel kesehatan tentang tips menjaga kesehatan selama kehamilan.', '/asset hospital/RSIA_BHP_LOGO5.png', CURDATE(), 'PUBLISHED'),
('Jadwal Dokter Spesialis Anak', 'Informasi jadwal praktik dokter spesialis anak di RSIA Buah Hati Pamulang.', '/asset hospital/RSIA_BHP_LOGO5.png', CURDATE(), 'PUBLISHED'),
('Layanan Vaksinasi COVID-19', 'RSIA Buah Hati Pamulang menyediakan layanan vaksinasi COVID-19 untuk masyarakat.', '/asset hospital/RSIA_BHP_LOGO5.png', CURDATE(), 'PUBLISHED'),
('Fasilitas Terbaru RSIA Buah Hati', 'Pengenalan fasilitas terbaru yang tersedia di RSIA Buah Hati Pamulang.', '/asset hospital/RSIA_BHP_LOGO5.png', CURDATE(), 'PUBLISHED');
EOF

    print_success "News data imported"
}

# Function untuk show data summary
show_summary() {
    print_status "Data import summary:"

    echo ""
    echo "📊 Database Summary:"
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
SELECT
    'doctor_schedule' as table_name, COUNT(*) as count FROM doctor_schedule
UNION ALL
SELECT 'doctor' as table_name, COUNT(*) as count FROM doctor
UNION ALL
SELECT 'services' as table_name, COUNT(*) as count FROM services
UNION ALL
SELECT 'news' as table_name, COUNT(*) as count FROM news;
EOF
}

# Main script
main() {
    print_status "Starting data import process..."

    check_containers
    import_basic_data
    import_services
    import_news
    show_summary

    print_success "Data import completed successfully!"
    print_status "You can now access the application at: http://localhost:8080"
}

# Run main function
main
