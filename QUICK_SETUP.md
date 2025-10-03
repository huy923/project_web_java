# Quick Setup Guide - Hotel Management System

## 🚀 **Fast Setup Instructions**

### **Step 1: Install Database**
```bash
# Use the MySQL-compatible database schema (recommended)
mysql -u root -p < hotel_database_mysql.sql

# Or if you're using MariaDB
mariadb -u root -p < hotel_database_mysql.sql
```

### **Step 2: Test Database Connection**
```bash
# Connect to the database (MySQL)
mysql -u hotel_app -p hotel_management

# Or if using MariaDB
mariadb -u hotel_app -p hotel_management

# Test queries
SELECT COUNT(*) FROM rooms;
SELECT COUNT(*) FROM guests;
SELECT COUNT(*) FROM bookings;
```

### **Step 3: Update Java Dependencies**
Add to your `pom.xml`:
```xml
<!-- For MySQL -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>

<!-- Or for MariaDB -->
<dependency>
    <groupId>org.mariadb.jdbc</groupId>
    <artifactId>mariadb-java-client</artifactId>
    <version>3.2.0</version>
</dependency>
```

### **Step 4: Update Database Configuration**
Use these connection settings:
- **Driver**: `com.mysql.cj.jdbc.Driver` (MySQL) or `org.mariadb.jdbc.Driver` (MariaDB)
- **URL**: `jdbc:mysql://localhost:3306/hotel_management` (MySQL) or `jdbc:mariadb://localhost:3306/hotel_management` (MariaDB)
- **Username**: `hotel_app`
- **Password**: `hotel_password_2024`

### **Step 5: Run Your Application**
```bash
# Start your Java application
mvn tomcat7:run
```

### **Step 6: Test the Interface**
- Open browser: `http://localhost:8080/my-web-app`
- You should see the hotel management dashboard
- All room statuses should display correctly

## 🔐 **Login Credentials**
- **Admin**: `admin` / `password`
- **Manager**: `manager` / `password`
- **Reception**: `reception` / `password`

## 📊 **What's Included**
- ✅ 18 rooms across 3 floors (4 room types: Standard, Deluxe, Suite, Family)
- ✅ 6 sample guests with Vietnamese names
- ✅ 6 active bookings with various statuses
- ✅ 8 hotel services (food, spa, laundry, transportation, entertainment)
- ✅ Payment records with multiple payment types
- ✅ Maintenance records with priority levels
- ✅ Guest reviews and ratings
- ✅ Inventory management system
- ✅ Reports generation system
- ✅ Stored procedures for business logic
- ✅ Database triggers for automatic updates
- ✅ Optimized indexes for performance

## 🆘 **Troubleshooting**

### **Database Connection Issues**
```bash
# Check MySQL/MariaDB status
sudo systemctl status mysql
# OR
sudo systemctl status mariadb

# Start MySQL/MariaDB if not running
sudo systemctl start mysql
# OR
sudo systemctl start mariadb

# Reset MySQL/MariaDB root password if needed
sudo mysql_secure_installation
# OR
sudo mariadb-secure-installation
```

### **JSP Compilation Errors**
- Clear Tomcat work directory: `rm -rf target/tomcat/work/`
- Restart the application: `mvn tomcat7:run`

### **Permission Issues**
```sql
-- Grant permissions to hotel_app user
GRANT ALL PRIVILEGES ON hotel_management.* TO 'hotel_app'@'localhost';
FLUSH PRIVILEGES;
```

## 📁 **File Summary**
- `hotel_database_mysql.sql` - Complete MySQL-compatible database schema (recommended)
- `src/main/webapp/index.jsp` - Hotel management interface
- `QUICK_SETUP.md` - This setup guide

## 🎉 **Success Indicators**
- Database installs without errors
- JSP compiles without syntax errors
- Application starts without connection errors
- Hotel dashboard displays with room statuses
- All modals open and function properly

---

**Ready to go!** Your hotel management system should now be fully functional! 🏨✨








