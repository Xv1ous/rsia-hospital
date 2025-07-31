#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo ""
echo "========================================"
echo "    HOSPITAL APP - MYSQL ACCESS"
echo "========================================"
echo ""
echo "Choose an option:"
echo ""
echo "[1] Connect to MySQL (Interactive)"
echo "[2] View Database Tables"
echo "[3] View Sample Data"
echo "[4] Backup Database"
echo "[5] Restore Database"
echo "[6] Reset Database"
echo "[7] Exit"
echo ""
read -p "Enter your choice (1-7): " choice

case $choice in
    1)
        echo ""
        echo "Connecting to MySQL database..."
        echo "Database: hospital"
        echo "Username: hospital_user"
        echo "Password: hospital_pass"
        echo ""
        echo "Type 'exit' to quit MySQL"
        echo ""
        docker exec -it -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital
        ;;
    2)
        echo ""
        echo "Showing database tables..."
        echo ""
        docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SHOW TABLES;"
        echo ""
        read -p "Press Enter to continue..."
        ;;
    3)
        echo ""
        echo "Showing sample data from main tables..."
        echo ""
        echo "=== DOCTORS ==="
        docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, name, specialization FROM doctor LIMIT 5;"
        echo ""
        echo "=== APPOINTMENTS ==="
        docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, patient_name, doctor_id, appointment_date FROM appointments LIMIT 5;"
        echo ""
        echo "=== NEWS ==="
        docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, title, created_at FROM news LIMIT 5;"
        echo ""
        read -p "Press Enter to continue..."
        ;;
    4)
        echo ""
        echo "Creating database backup..."
        BACKUP_FILE="hospital_backup_$(date +%Y%m%d_%H%M%S).sql"
        docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysqldump -u hospital_user hospital > "$BACKUP_FILE"
        echo "Backup saved as: $BACKUP_FILE"
        echo ""
        read -p "Press Enter to continue..."
        ;;
    5)
        echo ""
        echo "Available backup files:"
        ls -la *.sql 2>/dev/null | grep hospital_backup || echo "No backup files found"
        echo ""
        read -p "Enter backup filename (or press Enter to cancel): " backup_file
        if [ -n "$backup_file" ] && [ -f "$backup_file" ]; then
            echo "Restoring database from $backup_file..."
            docker exec -i -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital < "$backup_file"
            echo "Database restored successfully!"
        else
            echo "Invalid filename or file not found."
        fi
        echo ""
        read -p "Press Enter to continue..."
        ;;
    6)
        echo ""
        echo "⚠️  WARNING: This will reset the database!"
        echo "All data will be lost and replaced with initial data."
        echo ""
        read -p "Are you sure? Type 'yes' to continue: " confirm
        if [ "$confirm" = "yes" ]; then
            echo "Resetting database..."
            docker-compose -f "$PROJECT_ROOT/docker/docker-compose.dev.yml" down
            docker volume rm docker_mysql_data_dev 2>/dev/null || true
            docker-compose -f "$PROJECT_ROOT/docker/docker-compose.dev.yml" up -d
            echo "Database reset successfully!"
        else
            echo "Database reset cancelled."
        fi
        echo ""
        read -p "Press Enter to continue..."
        ;;
    7)
        echo ""
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo ""
        echo "Invalid choice. Please try again."
        read -p "Press Enter to continue..."
        "$0"
        ;;
esac
