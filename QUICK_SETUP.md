# Quick Setup Guide - Hotel Management System

## 🚀 **Fast Setup Instructions**

### **Step 1: Install Database**
```bash
# Use the simplified MariaDB schema (recommended)
mariadb -u root -p < hotel_database_simple.sql

# Or if you prefer the full version (may have compatibility issues)
mariadb -u root -p < hotel_database_mariadb.sql
```

### **Step 2: Test Database Connection**
```bash
# Connect to the database
mariadb -u hotel_app -p hotel_management

# Test queries
SELECT COUNT(*) FROM rooms;
SELECT COUNT(*) FROM guests;
SELECT COUNT(*) FROM bookings;
```

### **Step 3: Update Java Dependencies**
Add to your `pom.xml`:
```xml
<dependency>
    <groupId>org.mariadb.jdbc</groupId>
    <artifactId>mariadb-java-client</artifactId>
    <version>3.2.0</version>
</dependency>
```

### **Step 4: Update Database Configuration**
Use these connection settings:
- **Driver**: `org.mariadb.jdbc.Driver`
- **URL**: `jdbc:mariadb://localhost:3306/hotel_management`
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
- ✅ 18 rooms across 3 floors
- ✅ 6 sample guests
- ✅ 6 active bookings
- ✅ 8 hotel services
- ✅ Payment records
- ✅ Maintenance records
- ✅ Guest reviews

## 🆘 **Troubleshooting**

### **Database Connection Issues**
```bash
# Check MariaDB status
sudo systemctl status mariadb

# Start MariaDB if not running
sudo systemctl start mariadb

# Reset MariaDB root password if needed
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
- `hotel_database_simple.sql` - Simplified MariaDB schema (recommended)
- `hotel_database_mariadb.sql` - Full MariaDB schema
- `database_config_mariadb.properties` - MariaDB connection settings
- `src/main/webapp/index.jsp` - Hotel management interface
- `MARIADB_SETUP.md` - Detailed setup guide

## 🎉 **Success Indicators**
- Database installs without errors
- JSP compiles without syntax errors
- Application starts without connection errors
- Hotel dashboard displays with room statuses
- All modals open and function properly

---

**Ready to go!** Your hotel management system should now be fully functional! 🏨✨








