# 🏨 Hotel Management System

<div animate="fadeInUp" style="animation-duration: 1s;" align="center">

![Hotel Management System](https://img.shields.io/badge/Hotel-Management%20System-blue?style=for-the-badge&logo=hotel)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-FF6B6B?style=for-the-badge&logo=java&logoColor=white)

**A comprehensive web-based hotel management system built with Java, JSP, and MySQL**

[🚀 Quick Start](#-quick-start) • [📋 Features](#-features) • [🛠️ Setup](#️-setup) • [📱 Screenshots](#-screenshots) • [🔧 Configuration](#-configuration)

</div>

---

## 🌟 Overview

Welcome to the **Hotel Management System** - a modern, feature-rich web application designed to streamline hotel operations. Whether you're managing a boutique hotel or a large resort, this system provides all the tools you need to handle reservations, guest services, room management, and more.

### 🎯 What Makes This Special?

- **🏠 Complete Room Management**: Track 18 rooms across 3 floors with real-time status updates
- **👥 Multi-Role System**: Support for Admin, Manager, Reception, Housekeeping, and Maintenance roles
- **💳 Integrated Payment Processing**: Handle multiple payment methods with transaction tracking
- **📊 Advanced Reporting**: Generate occupancy reports, revenue analysis, and guest insights
- **🔧 Maintenance Tracking**: Monitor room issues with priority-based assignment system
- **📱 Responsive Design**: Works seamlessly on desktop, tablet, and mobile devices

---

## 🚀 Quick Start

### Prerequisites

- Java 17 or higher
- Maven 3.6+
- MySQL 5.7+ or MariaDB 10.3+
- Tomcat 9+

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/huy923/project_web_java.git
cd project_web_java
```

### 2️⃣ Database Setup

```bash
# Install the database schema
mysql -u root -p < hotel_database_mysql.sql
```

If you have some error mysql is not found you just copy all code in file `hotel_database_mysql.sql` and then open xampp and then click on tap `sql` 

### 3️⃣ Run the Application

```bash
# Clean and compile
mvn clean compile

# Start the server
mvn tomcat9:run
```

### 4️⃣ Access the System

🌐 Open your browser and navigate to: **http://localhost:8082/**

---

## 📋 Features

### 🏨 Core Hotel Operations

- **Room Management**: Real-time room status tracking (Available, Occupied, Maintenance, Cleaning)
- **Guest Registration**: Complete guest profiles with ID verification and contact information
- **Booking System**: Advanced reservation management with check-in/check-out workflows
- **Payment Processing**: Support for cash, credit cards, bank transfers, and online payments

### 👥 User Management

- **Role-Based Access**: Different permission levels for various staff roles
- **Staff Profiles**: Complete employee management with contact details and role assignments
- **Authentication**: Secure login system with password protection

### 🛠️ Advanced Features

- **Service Management**: Track additional services like spa, laundry, transportation
- **Maintenance System**: Issue reporting and tracking with priority levels
- **Inventory Control**: Monitor hotel supplies and amenities
- **Guest Reviews**: Collect and manage customer feedback
- **Reporting Dashboard**: Generate comprehensive business reports

### 📊 Sample Data Included

- ✅ **18 Rooms** across 3 floors (Standard, Deluxe, Suite, Family types)
- ✅ **6 Sample Guests** with Vietnamese names and realistic data
- ✅ **6 Active Bookings** with various statuses and payment records
- ✅ **8 Hotel Services** covering food, spa, laundry, and transportation
- ✅ **Maintenance Records** with priority-based assignment
- ✅ **Guest Reviews** and ratings system

---

## 🛠️ Setup

### Database Configuration

The system uses a comprehensive MySQL database with the following structure:

```sql
-- Key Tables
- users (staff management)
- rooms (room inventory)
- guests (customer database)
- bookings (reservations)
- payments (transaction records)
- services (additional offerings)
- maintenance_records (issue tracking)
- reviews (customer feedback)
```

### Default Login Credentials

| Role | Username | Password | Access Level |
|------|----------|----------|--------------|
| 🔑 **Admin** | `admin` | `password` | Full system access |
| 👔 **Manager** | `manager` | `password` | Management functions |
| 🏢 **Reception** | `reception` | `password` | Guest services |

### Port Configuration

The default port is **8082**. To change it, modify the `pom.xml` file:

```xml
<configuration>
    <port>8082</port> <!-- Change this number -->
</configuration>
```

---

## 📱 Screenshots

> *Screenshots would be added here showing the dashboard, room management, booking system, etc.*

---

## 🔧 Configuration

### Java Dependencies

Add to your `pom.xml`:

```xml
<!-- MySQL Driver -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>

<!-- MariaDB Driver (Alternative) -->
<dependency>
    <groupId>org.mariadb.jdbc</groupId>
    <artifactId>mariadb-java-client</artifactId>
    <version>3.2.0</version>
</dependency>
```

### Database Connection Settings

```properties
# Database Configuration
driver=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/hotel_management
username=hotel_app
password=hotel_password
```

---

## 🚀 Deployment

### Local Development

```bash
mvn tomcat9:run
```

### Production Deployment

```bash
# Build the application
mvn clean package

# Deploy to Tomcat
mvn tomcat9:deploy
```

### Server Deployment

```bash
# Copy WAR file to server
scp -P 2222 target/my-web-app.war root@localhost:/var/www/html
```

---

## 🆘 Troubleshooting

### Common Issues

**Database Connection Problems**

```bash
# Check MySQL/MariaDB status
sudo systemctl status mysql
sudo systemctl start mysql
```

**Port Already in Use**

```bash
# Kill process using port 8080
sudo lsof -ti:8080 | xargs kill -9
```

**JSP Compilation Errors**

```bash
# Clear Tomcat work directory
rm -rf target/tomcat/work/
mvn tomcat9:run
```

---

## 📁 Project Structure

```
my-web-app/
├── src/main/java/com/example/servlet/    # Java servlets
├── src/main/webapp/                     # JSP pages and static resources
│   ├── index.jsp                        # Main dashboard
│   ├── login.jsp                        # Authentication
│   ├── signup.jsp                       # User registration
│   └── sections/                        # Feature modules
├── hotel_database_mysql.sql             # Database schema
├── QUICK_SETUP.md                       # Quick setup guide
└── pom.xml                              # Maven configuration
```

---

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Huy**

- GitHub: [@huy923](https://github.com/huy923)

**Hiep**

- GitHub: [@hiep](https://github.com/hiep)

**Son**

- GitHub: [@son](https://github.com/son)

---
## 🙏 Acknowledgments

- Built with ❤️ using Java, JSP, and MySQL
- Inspired by modern hotel management needs
- Designed for scalability and maintainability

---

## Error

- if you see some error like `HTTP Status 500 - java.sql.SQLException: Access denied for user 'hotel_app'@'localhost' (using password: YES)` mabe you did't create user in mysql to fix that error you just run copy code below and paste it in mysql:

```bash
CREATE USER IF NOT EXISTS 'hotel_app'@'localhost' 
IDENTIFIED BY 'hotel_password';

GRANT SELECT, INSERT, UPDATE, DELETE 
ON hotel_management.* TO 'hotel_app'@'localhost';

FLUSH PRIVILEGES;

UPDATE hotel_management.rooms
SET last_cleaned = CURRENT_TIMESTAMP
WHERE status = 'available';

```

- or you just change user to root and your password to empty in file [Database](/src/main/java/util/DatabaseConnection.java)