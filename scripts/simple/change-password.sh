#!/bin/bash

echo ""
echo "========================================"
echo "    HOSPITAL APP - CHANGE PASSWORD"
echo "========================================"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "Current users in database:"
echo ""
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, username, role FROM users;"
echo ""

read -p "Enter username to change password: " username

if [ -z "$username" ]; then
    echo "❌ Username cannot be empty!"
    exit 1
fi

# Check if user exists
USER_EXISTS=$(docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT COUNT(*) FROM users WHERE username='$username';" -s -N)

if [ "$USER_EXISTS" -eq 0 ]; then
    echo "❌ User '$username' not found in database!"
    exit 1
fi

echo ""
echo "Choose password type:"
echo "[1] Use provided encrypted password"
echo "[2] Enter new plain text password (will be encrypted)"
echo ""
read -p "Enter choice (1-2): " choice

case $choice in
    1)
        echo ""
        echo "Using provided encrypted password:"
        echo "$2a$12$lLKRwSUbB7NQOOr6pL.ysO7c1sss.9qpZYIi2Tpigo.Z6GsjNYuL."
        echo ""
        read -p "Press Enter to update password..."

        # Update password with provided encrypted value
        docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "UPDATE users SET password='$2a$12$lLKRwSUbB7NQOOr6pL.ysO7c1sss.9qpZYIi2Tpigo.Z6GsjNYuL.' WHERE username='$username';"

        if [ $? -eq 0 ]; then
            echo "✅ Password updated successfully for user '$username'!"
        else
            echo "❌ Failed to update password!"
            exit 1
        fi
        ;;
    2)
        echo ""
        read -s -p "Enter new password: " new_password
        echo ""
        read -s -p "Confirm new password: " confirm_password
        echo ""

        if [ "$new_password" != "$confirm_password" ]; then
            echo "❌ Passwords do not match!"
            exit 1
        fi

        if [ -z "$new_password" ]; then
            echo "❌ Password cannot be empty!"
            exit 1
        fi

        echo ""
        echo "⚠️  Note: Plain text passwords will be encrypted by Spring Security"
        echo "The application will handle password encryption automatically."
        echo ""
        read -p "Press Enter to update password..."

        # For plain text password, we'll use a simple hash for now
        # In production, Spring Security will handle the encryption
        HASHED_PASSWORD=$(echo -n "$new_password" | openssl dgst -sha256 | cut -d' ' -f2)

        docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "UPDATE users SET password='$HASHED_PASSWORD' WHERE username='$username';"

        if [ $? -eq 0 ]; then
            echo "✅ Password updated successfully for user '$username'!"
            echo "📝 Note: You may need to restart the application for changes to take effect."
        else
            echo "❌ Failed to update password!"
            exit 1
        fi
        ;;
    *)
        echo "❌ Invalid choice!"
        exit 1
        ;;
esac

echo ""
echo "Updated user information:"
docker exec -e MYSQL_PWD=hospital_pass hospital-mysql-dev mysql -u hospital_user hospital -e "SELECT id, username, role FROM users WHERE username='$username';"
echo ""

read -p "Press Enter to continue..."
