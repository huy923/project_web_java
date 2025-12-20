package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/hotel_management?useSSL=false&serverTimezone=UTC";
    private static final String USER = "hotel_app"; // change to root if have error user
    private static final String PASSWORD = "hotel_password"; // change your password

    public DatabaseConnection() {
    }
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
