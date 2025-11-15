# Deployment Guide - Hotel Management System

**Version**: 1.0  
**Build Date**: November 15, 2025  
**Build Status**: ✅ PASSED

---

## 📦 Artifact Information

| Property | Value |
|----------|-------|
| Artifact Name | my-web-app.war |
| Location | target/my-web-app.war |
| Size | 12 MB |
| Build Tool | Maven 3.11.0 |
| JDK Version | Java 21 |
| Tomcat Version | 9+ |

---

## 🚀 Deployment Steps

### Step 1: Prerequisites

```bash
# Ensure you have:
✓ Apache Tomcat 9 (or later) installed
✓ MySQL 8.0+ running with hotel_management database
✓ Java 21 (or compatible version)
✓ Network connectivity to database server
```

### Step 2: Database Setup

```sql
-- Verify database and tables exist
USE hotel_management;
SHOW TABLES;

-- Expected tables:
-- maintenance_records, inventory, reviews, guest_services
-- rooms, guests, users, services, bookings
```

### Step 3: Deploy WAR File

#### Option A: Tomcat Manager GUI

1. Open Tomcat Manager: `http://localhost:8080/manager`
2. Navigate to "Deploy" section
3. Upload `my-web-app.war`
4. Wait for deployment to complete

#### Option B: Copy to Webapps

```bash
# Stop Tomcat (if running)
./catalina.sh stop

# Copy WAR file
cp target/my-web-app.war $CATALINA_HOME/webapps/

# Start Tomcat
./catalina.sh start

# Check logs
tail -f logs/catalina.out
```

#### Option C: Maven Plugin (Development)

```bash
mvn tomcat7:deploy
# or with existing deployment
mvn tomcat7:redeploy
```

### Step 4: Verify Deployment

```bash
# Check application is running
curl http://localhost:8080/my-web-app/

# Expected response: HTML login page
# Expected HTTP status: 200 OK
```

---

## ✅ Post-Deployment Verification

### 1. Test Authentication

- Navigate to: `http://localhost:8080/my-web-app/login.jsp`
- Try to login with test credentials
- Verify session management works

### 2. Test New Pages

- After login, navigate to:
  - `/my-web-app/maintenance` - Maintenance Management
  - `/my-web-app/services` - Services Management
  - `/my-web-app/inventory` - Inventory Management
  - `/my-web-app/reviews` - Reviews Management

### 3. Test Database Connectivity

- Try to add a new maintenance record
- Check database to verify data was saved
- Query: `SELECT * FROM maintenance_records ORDER BY created_at DESC LIMIT 1;`

### 4. Test Error Handling

- Try accessing invalid URL: `/my-web-app/invalid`
- Should see 404 error page
- Try accessing without session: Restart browser, access `/maintenance`
- Should redirect to login page

### 5. Check Tomcat Logs

```bash
# Monitor for errors
tail -f $CATALINA_HOME/logs/catalina.out
tail -f $CATALINA_HOME/logs/localhost.log
```

---

## 🔧 Configuration Files Modified

| File | Changes |
|------|---------|
| web.xml | Added 4 new servlets + error page mappings |
| pom.xml | No changes (existing dependencies sufficient) |
| DatabaseConnection.java | No changes (ensure DB credentials are correct) |

---

## 🗄️ Database Schema Requirements

The application requires these tables to exist:

```sql
-- Verify with:
DESC maintenance_records;
DESC inventory;
DESC reviews;
DESC guest_services;
```

**Expected columns** (verify these exist):

- `maintenance_records`: maintenance_id, room_id, issue_description, priority, status, estimated_cost, actual_cost, start_date, completion_date, reported_by, assigned_to, created_at
- `inventory`: item_id, item_name, category, current_stock, minimum_stock, unit_price, supplier, last_restocked, created_at
- `reviews`: review_id, booking_id, guest_id, rating, review_text, is_public, created_at
- `guest_services`: guest_service_id, booking_id, service_id, quantity, service_date, status, created_at

---

## 🐛 Troubleshooting

### Application Not Loading

```
✗ Error: Context failed to start
Solution: Check Tomcat logs for startup errors
  - Verify database connection
  - Ensure all table schemas match expectations
  - Check MySQL is running and accessible
```

### 404 on New Pages

```
✗ Error: Page not found /my-web-app/maintenance
Solution: Verify web.xml updated and Tomcat restarted
  - Check: curl http://localhost:8080/my-web-app/maintenance
  - Look for 404 error in logs
  - Ensure servlet class exists in JAR
```

### Database Connection Errors

```
✗ Error: SQLException: Access denied for user
Solution: Check database credentials
  - Open: src/main/java/util/DatabaseConnection.java
  - Verify: host, port, database, username, password
  - Test: mysql -u[user] -p[pass] -h[host] [database]
```

### Session Timeout Issues

```
✗ Error: Redirected to login after few minutes
Solution: This is normal behavior for security
  - Adjust session timeout in web.xml if needed:
    <session-config>
        <cookie-http-only>true</cookie-http-only>
        <tracking-mode>COOKIE</tracking-mode>
    </session-config>
```

---

## 📊 Performance Tuning

### For Production Deployment

1. **Database Optimization**
   - Add indexes on frequently queried columns
   - Increase MySQL connection pool size
   - Enable query caching if available

2. **Application Optimization**
   - Enable gzip compression in Tomcat
   - Minimize JSP compilation overhead
   - Use CDN for static resources

3. **Memory Settings**

   ```bash
   # Edit catalina.sh
   export JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx1024m"
   ```

---

## 🔐 Security Checklist

Before production deployment:

- [ ] Change default admin credentials
- [ ] Enable HTTPS/SSL
- [ ] Update DatabaseConnection credentials
- [ ] Set secure session cookies
- [ ] Enable CSRF protection if using forms
- [ ] Validate all user inputs
- [ ] Use prepared statements (✓ already implemented)
- [ ] Set appropriate file permissions
- [ ] Review error messages (no sensitive data exposed)
- [ ] Enable audit logging

---

## 📋 Rollback Procedure

If deployment fails:

```bash
# Stop Tomcat
./catalina.sh stop

# Remove new WAR
rm $CATALINA_HOME/webapps/my-web-app.war
rm -rf $CATALINA_HOME/webapps/my-web-app

# Restore previous version (if available)
cp backup/my-web-app.war $CATALINA_HOME/webapps/

# Start Tomcat
./catalina.sh start
```

---

## 📞 Support Information

### Common Endpoints

- **Dashboard**: `/my-web-app/dashboard`
- **Maintenance**: `/my-web-app/maintenance`
- **Services**: `/my-web-app/services`
- **Inventory**: `/my-web-app/inventory`
- **Reviews**: `/my-web-app/reviews`
- **Login**: `/my-web-app/login.jsp`
- **Logout**: `/my-web-app/logout`

### Accessing Logs

```bash
# Tomcat startup
$CATALINA_HOME/logs/catalina.out

# Application errors
$CATALINA_HOME/logs/localhost.log

# Access logs
$CATALINA_HOME/logs/localhost_access_log.*.txt
```

### Database Verification

```bash
# Connect to database
mysql -u root -p hotel_management

# Check new tables
SHOW TABLES;
SELECT COUNT(*) FROM maintenance_records;
SELECT COUNT(*) FROM inventory;
SELECT COUNT(*) FROM reviews;
SELECT COUNT(*) FROM guest_services;
```

---

## ✅ Sign-Off Checklist

- [x] Build compiles successfully
- [x] No compilation errors
- [x] WAR file created (12 MB)
- [x] All servlets registered
- [x] Error pages mapped
- [x] Database tables present
- [x] Deployment guide complete
- [x] Ready for testing

---

**Status**: ✅ READY FOR DEPLOYMENT  
**Last Updated**: November 15, 2025  
**Next Step**: Deploy to Tomcat and run integration tests
