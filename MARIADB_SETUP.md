# Hotel Management System - MariaDB Setup Guide

## 📋 Overview
This guide will help you set up the MariaDB database for your Hotel Management System.

## 🛠️ Prerequisites
- MariaDB Server 10.3 or higher
- MariaDB client tools
- Java application server (Tomcat)

## 📁 Files for MariaDB
- `hotel_database_mariadb.sql` - MariaDB-compatible database schema
- `database_config_mariadb.properties` - MariaDB connection configuration
- `MARIADB_SETUP.md` - This setup guide

## 🚀 Quick Setup

### Step 1: Create the Database
```bash
# Using MariaDB command line
mariadb -u root -p < hotel_database_mariadb.sql

# Or if you prefer mysql command (deprecated but works)
mysql -u root -p < hotel_database_mariadb.sql
```

### Step 2: Verify Installation
```sql
-- Connect to the database
USE hotel_management;

-- Check if tables were created
SHOW TABLES;

-- Check sample data
SELECT * FROM rooms LIMIT 5;
SELECT * FROM guests LIMIT 5;
SELECT * FROM bookings LIMIT 5;
```

### Step 3: Update Application Configuration
1. Copy `database_config_mariadb.properties` to your application's resources folder
2. Update the database connection settings if needed
3. Add MariaDB JDBC driver to your project dependencies

## 📊 Key MariaDB Compatibility Fixes

### 1. AUTO_INCREMENT Syntax
- **Fixed**: Changed `INT PRIMARY KEY AUTO_INCREMENT` to `INT AUTO_INCREMENT PRIMARY KEY`
- **Reason**: MariaDB prefers AUTO_INCREMENT before PRIMARY KEY

### 2. Character Set
- **Added**: `CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`
- **Reason**: Better Unicode support for Vietnamese text

### 3. DECIMAL Precision
- **Fixed**: All price columns use `DECIMAL(12,2)`
- **Reason**: Supports Vietnamese currency values up to 99,999,999,999.99 VNĐ

### 4. JSON Support
- **Maintained**: JSON column type for reports parameters
- **Note**: MariaDB 10.2+ supports native JSON

## 🔐 Default Login Credentials

### Application Database User
- **Username**: hotel_app
- **Password**: hotel_password_2024
- **Permissions**: Full CRUD access to hotel_management database

### Admin Account
- **Username**: admin
- **Password**: password
- **Role**: System Administrator

## 🔧 Database Connection in Java

### Maven Dependencies (add to pom.xml)
```xml
<dependency>
    <groupId>org.mariadb.jdbc</groupId>
    <artifactId>mariadb-java-client</artifactId>
    <version>3.2.0</version>
</dependency>
```

### Connection Example
```java
String url = "jdbc:mariadb://localhost:3306/hotel_management";
String username = "hotel_app";
String password = "hotel_password_2024";

Connection conn = DriverManager.getConnection(url, username, password);
```

## 🛡️ MariaDB-Specific Security

### 1. Authentication
```sql
-- Secure the root account
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_strong_password';
FLUSH PRIVILEGES;
```

### 2. Application User
```sql
-- Create application user with limited privileges
CREATE USER 'hotel_app'@'localhost' IDENTIFIED BY 'strong_app_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON hotel_management.* TO 'hotel_app'@'localhost';
FLUSH PRIVILEGES;
```

## 📈 Performance Optimization

### MariaDB Configuration
Add to `/etc/mysql/mariadb.conf.d/50-server.cnf`:
```ini
[mysqld]
# InnoDB settings
innodb_buffer_pool_size = 256M
innodb_log_file_size = 64M
innodb_flush_log_at_trx_commit = 2

# Character set
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# Connection settings
max_connections = 200
wait_timeout = 600
```

## 🔄 Maintenance Tasks

### Daily Tasks
```sql
-- Check database status
SHOW PROCESSLIST;
SHOW STATUS LIKE 'Threads_connected';

-- Monitor slow queries
SHOW VARIABLES LIKE 'slow_query_log';
```

### Weekly Tasks
```sql
-- Optimize tables
OPTIMIZE TABLE rooms, bookings, guests;

-- Check table sizes
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size in MB"
FROM information_schema.TABLES 
WHERE table_schema = 'hotel_management';
```

## 🆘 Troubleshooting

### Common Issues

1. **"Incorrect syntax near 'AUTO_INCREMENT'"**
   - **Solution**: Use the MariaDB-compatible SQL file
   - **Command**: `mariadb -u root -p < hotel_database_mariadb.sql`

2. **"Access denied for user 'root'@'localhost'"**
   - **Solution**: Reset MariaDB root password
   - **Command**: `sudo mariadb-secure-installation`

3. **"Unknown database 'hotel_management'"**
   - **Solution**: Create database first
   - **Command**: `CREATE DATABASE hotel_management;`

4. **Connection refused**
   - **Check**: MariaDB service status
   - **Command**: `sudo systemctl status mariadb`

### MariaDB Service Management
```bash
# Start MariaDB
sudo systemctl start mariadb

# Stop MariaDB
sudo systemctl stop mariadb

# Restart MariaDB
sudo systemctl restart mariadb

# Check status
sudo systemctl status mariadb
```

## 📝 Next Steps

1. **Test the Database**
   ```sql
   -- Connect and test
   mariadb -u hotel_app -p hotel_management
   
   -- Run a test query
   SELECT COUNT(*) FROM rooms;
   ```

2. **Update Your Application**
   - Use MariaDB JDBC driver
   - Update connection string to use `jdbc:mariadb://`
   - Test connection with provided credentials

3. **Production Setup**
   - Change all default passwords
   - Configure MariaDB security settings
   - Set up regular backups

---

🎉 **Congratulations!** Your hotel management database is now ready for MariaDB!
