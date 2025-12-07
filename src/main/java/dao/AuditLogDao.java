package dao;

import util.DatabaseConnection;
import java.sql.*;
import java.util.*;

public class AuditLogDao {

    // Log an action
    public boolean logAction(int userId, String action, String module, String entityType, 
                            Integer entityId, String oldValue, String newValue, 
                            String ipAddress, String status) throws SQLException {
        String sql = "INSERT INTO audit_logs (user_id, action, module, entity_type, entity_id, " +
                "old_value, new_value, ip_address, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, action);
            ps.setString(3, module);
            ps.setString(4, entityType);
            ps.setObject(5, entityId);
            ps.setString(6, oldValue);
            ps.setString(7, newValue);
            ps.setString(8, ipAddress);
            ps.setString(9, status);
            return ps.executeUpdate() == 1;
        }
    }

    // Get audit logs
    public List<Map<String, Object>> getAuditLogs(int limit, int offset) throws SQLException {
        String sql = "SELECT a.*, u.full_name FROM audit_logs a " +
                "LEFT JOIN users u ON a.user_id = u.user_id " +
                "ORDER BY a.timestamp DESC LIMIT ? OFFSET ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> logs = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> log = new HashMap<>();
                    log.put("audit_id", rs.getInt("audit_id"));
                    log.put("user_id", rs.getInt("user_id"));
                    log.put("full_name", rs.getString("full_name"));
                    log.put("action", rs.getString("action"));
                    log.put("module", rs.getString("module"));
                    log.put("entity_type", rs.getString("entity_type"));
                    log.put("entity_id", rs.getObject("entity_id"));
                    log.put("old_value", rs.getString("old_value"));
                    log.put("new_value", rs.getString("new_value"));
                    log.put("ip_address", rs.getString("ip_address"));
                    log.put("status", rs.getString("status"));
                    log.put("timestamp", rs.getTimestamp("timestamp"));
                    logs.add(log);
                }
                return logs;
            }
        }
    }

    // Get user audit logs
    public List<Map<String, Object>> getUserAuditLogs(int userId, int limit, int offset) throws SQLException {
        String sql = "SELECT * FROM audit_logs WHERE user_id = ? " +
                "ORDER BY timestamp DESC LIMIT ? OFFSET ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> logs = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> log = new HashMap<>();
                    log.put("audit_id", rs.getInt("audit_id"));
                    log.put("action", rs.getString("action"));
                    log.put("module", rs.getString("module"));
                    log.put("entity_type", rs.getString("entity_type"));
                    log.put("entity_id", rs.getObject("entity_id"));
                    log.put("timestamp", rs.getTimestamp("timestamp"));
                    logs.add(log);
                }
                return logs;
            }
        }
    }

    // Get audit logs by module
    public List<Map<String, Object>> getAuditLogsByModule(String module, int limit, int offset) throws SQLException {
        String sql = "SELECT a.*, u.full_name FROM audit_logs a " +
                "LEFT JOIN users u ON a.user_id = u.user_id " +
                "WHERE a.module = ? ORDER BY a.timestamp DESC LIMIT ? OFFSET ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, module);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> logs = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> log = new HashMap<>();
                    log.put("audit_id", rs.getInt("audit_id"));
                    log.put("full_name", rs.getString("full_name"));
                    log.put("action", rs.getString("action"));
                    log.put("entity_type", rs.getString("entity_type"));
                    log.put("timestamp", rs.getTimestamp("timestamp"));
                    logs.add(log);
                }
                return logs;
            }
        }
    }

    // Get total audit logs count
    public int getTotalAuditLogsCount() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM audit_logs";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }
}
