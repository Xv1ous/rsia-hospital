#!/bin/bash

# View Data Script untuk RSIA Buah Hati Pamulang
# Usage: ./scripts/view-data.sh [summary|schedule|doctors|services|news]

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
    if ! sudo docker ps | grep -q "hospital-mysql-dev"; then
        print_error "MySQL container is not running. Please start the containers first."
        exit 1
    fi
}

# Function untuk show data summary
show_summary() {
    print_status "Database Summary:"
    echo ""
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

# Function untuk show doctor schedule
show_schedule() {
    print_status "Doctor Schedule (first 10 records):"
    echo ""
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
SELECT name, day, time, specialization
FROM doctor_schedule
ORDER BY day, time
LIMIT 10;
EOF
}

# Function untuk show doctors
show_doctors() {
    print_status "Doctors List:"
    echo ""
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
SELECT DISTINCT name, specialization
FROM doctor_schedule
ORDER BY specialization, name;
EOF
}

# Function untuk show services
show_services() {
    print_status "Services List:"
    echo ""
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
SELECT name, description, category FROM services;
EOF
}

# Function untuk show news
show_news() {
    print_status "News List:"
    echo ""
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
SELECT title, date, status FROM news;
EOF
}

# Function untuk show schedule by day
show_schedule_by_day() {
    local day=$1
    print_status "Schedule for $day:"
    echo ""
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << EOF
SELECT name, time, specialization
FROM doctor_schedule
WHERE day = '$day'
ORDER BY time;
EOF
}

# Function untuk show schedule by specialization
show_schedule_by_specialization() {
    local spec=$1
    print_status "Schedule for $spec:"
    echo ""
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << EOF
SELECT name, day, time
FROM doctor_schedule
WHERE specialization LIKE '%$spec%'
ORDER BY FIELD(day, 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'), time;
EOF
}

# Function untuk show statistics
show_statistics() {
    print_status "Database Statistics:"
    echo ""
    sudo docker exec -i hospital-mysql-dev mysql -u hospital_user -p'hospital_pass' hospital << 'EOF'
SELECT 'Doctors per Specialization' as stat_type, specialization, COUNT(DISTINCT name) as count
FROM doctor_schedule
GROUP BY specialization
ORDER BY count DESC;

SELECT 'Schedule per Day' as stat_type, day, COUNT(*) as count
FROM doctor_schedule
GROUP BY day
ORDER BY FIELD(day, 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu');
EOF
}

# Main script logic
case "${1:-summary}" in
    "summary")
        check_containers
        show_summary
        ;;
    "schedule")
        check_containers
        show_schedule
        ;;
    "doctors")
        check_containers
        show_doctors
        ;;
    "services")
        check_containers
        show_services
        ;;
    "news")
        check_containers
        show_news
        ;;
    "stats")
        check_containers
        show_statistics
        ;;
    "day")
        if [ -z "$2" ]; then
            print_error "Please specify a day (e.g., Senin, Selasa, etc.)"
            exit 1
        fi
        check_containers
        show_schedule_by_day "$2"
        ;;
    "spec")
        if [ -z "$2" ]; then
            print_error "Please specify a specialization (e.g., Anak, Kandungan, etc.)"
            exit 1
        fi
        check_containers
        show_schedule_by_specialization "$2"
        ;;
    *)
        echo "Usage: $0 [summary|schedule|doctors|services|news|stats|day <hari>|spec <spesialisasi>]"
        echo ""
        echo "Commands:"
        echo "  summary              - Show database summary"
        echo "  schedule             - Show doctor schedule (first 10)"
        echo "  doctors              - Show all doctors"
        echo "  services             - Show all services"
        echo "  news                 - Show all news"
        echo "  stats                - Show database statistics"
        echo "  day <hari>           - Show schedule for specific day"
        echo "  spec <spesialisasi>  - Show schedule for specific specialization"
        echo ""
        echo "Examples:"
        echo "  $0 day Senin"
        echo "  $0 spec Anak"
        exit 1
        ;;
esac
