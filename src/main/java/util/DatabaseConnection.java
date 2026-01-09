package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = " /hotel_management?useSSL=false&serverTimezone=UTC";
    private static final String USER = System.getenv("MYSQL_USER") != null ? System.getenv("MYSQL_USER") : "root";
    private static final String PASSWORD = System.getenv("MYSQL_PASSWORD") != null ? System.getenv("MYSQL_PASSWORD") : "";

    public DatabaseConnection() {
    }
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
