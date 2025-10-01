package com.example.dao;

import com.example.model.User;
import com.example.util.DatabaseConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class UserDao {
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT user_id, username, password, email, full_name, phone, role, is_active FROM users WHERE username = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setPasswordHash(rs.getString("password"));
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name"));
                    u.setPhone(rs.getString("phone"));
                    u.setRole(rs.getString("role"));
                    u.setActive(rs.getBoolean("is_active"));
                    return u;
                }
            }
        }
        return null;
    }

    public boolean validatePassword(String plaintext, String hashed) {
        if (hashed == null || hashed.isEmpty())
            return false;
        // Support pre-seeded bcrypt hashes
        if (hashed.startsWith("$2a$") || hashed.startsWith("$2b$") || hashed.startsWith("$2y$")) {
            return BCrypt.checkpw(plaintext, hashed);
        }
        // Fallback: plain text (not recommended) for legacy data
        return plaintext.equals(hashed);
    }

    public boolean createUser(String username, String password, String email, String fullName, String phone,
            String role) throws SQLException {
        String sql = "INSERT INTO users (username, password, email, full_name, phone, role, is_active) VALUES (?,?,?,?,?,?,TRUE)";
        String hash = BCrypt.hashpw(password, BCrypt.gensalt(10));
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hash);
            ps.setString(3, email);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            ps.setString(6, role);
            return ps.executeUpdate() == 1;
        }
    }
}
