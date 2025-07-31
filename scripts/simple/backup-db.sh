#!/bin/bash

echo ""
echo "========================================"
echo "    HOSPITAL APP - BACKUP DATABASE"
echo "========================================"
echo ""

# Create backup filename with timestamp
BACKUP_FILE="hospital_backup_$(date +%Y%m%d_%H%M%S).sql"

echo "Creating database backup..."
echo "Backup file: $BACKUP_FILE"
echo ""

# Create backup
docker exec hospital-mysql-dev mysqldump -u hospital_user -phospital_pass hospital > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Backup created successfully!"
    echo "📁 File: $BACKUP_FILE"
    echo "📊 Size: $(du -h "$BACKUP_FILE" | cut -f1)"
else
    echo "❌ Backup failed!"
    exit 1
fi

echo ""
read -p "Press Enter to continue..."
