package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MaintenanceDao {

    public List<Map<String, Object>> getAllMaintenanceRecords() throws SQLException {
        String sql = "SELECT m.maintenance_id, m.room_id, m.issue_description, m.priority, m.status, " +
                "m.estimated_cost, m.actual_cost, m.start_date, m.completion_date, " +
                "r.room_number, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                "FROM maintenance_records m " +
                "JOIN rooms r ON m.room_id = r.room_id " +
                "LEFT JOIN users u1 ON m.reported_by = u1.user_id " +
                "LEFT JOIN users u2 ON m.assigned_to = u2.user_id " +
                "ORDER BY m.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> records = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> record = new HashMap<>();
                record.put("maintenance_id", rs.getInt("maintenance_id"));
                record.put("room_id", rs.getInt("room_id"));
                record.put("room_number", rs.getString("room_number"));
                record.put("issue_description", rs.getString("issue_description"));
                record.put("priority", rs.getString("priority"));
                record.put("status", rs.getString("status"));
                record.put("estimated_cost", rs.getBigDecimal("estimated_cost"));
                record.put("actual_cost", rs.getBigDecimal("actual_cost"));
                record.put("start_date", rs.getTimestamp("start_date"));
                record.put("completion_date", rs.getTimestamp("completion_date"));
                record.put("reported_by_name", rs.getString("reported_by_name"));
                record.put("assigned_to_name", rs.getString("assigned_to_name"));
                records.add(record);
            }
            return records;
        }
    }

    public List<Map<String, Object>> getMaintenanceByRoom(int roomId) throws SQLException {
        String sql = "SELECT m.*, r.room_number, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                "FROM maintenance_records m " +
                "JOIN rooms r ON m.room_id = r.room_id " +
                "LEFT JOIN users u1 ON m.reported_by = u1.user_id " +
                "LEFT JOIN users u2 ON m.assigned_to = u2.user_id " +
                "WHERE m.room_id = ? ORDER BY m.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> records = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    record.put("maintenance_id", rs.getInt("maintenance_id"));
                    record.put("room_id", rs.getInt("room_id"));
                    record.put("room_number", rs.getString("room_number"));
                    record.put("issue_description", rs.getString("issue_description"));
                    record.put("priority", rs.getString("priority"));
                    record.put("status", rs.getString("status"));
                    record.put("estimated_cost", rs.getBigDecimal("estimated_cost"));
                    record.put("actual_cost", rs.getBigDecimal("actual_cost"));
                    record.put("start_date", rs.getTimestamp("start_date"));
                    record.put("completion_date", rs.getTimestamp("completion_date"));
                    records.add(record);
                }
                return records;
            }
        }
    }

    public List<Map<String, Object>> getMaintenanceByStatus(String status) throws SQLException {
        String sql = "SELECT m.*, r.room_number, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                "FROM maintenance_records m " +
                "JOIN rooms r ON m.room_id = r.room_id " +
                "LEFT JOIN users u1 ON m.reported_by = u1.user_id " +
                "LEFT JOIN users u2 ON m.assigned_to = u2.user_id " +
                "WHERE m.status = ? ORDER BY m.priority DESC, m.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> records = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    record.put("maintenance_id", rs.getInt("maintenance_id"));
                    record.put("room_id", rs.getInt("room_id"));
                    record.put("room_number", rs.getString("room_number"));
                    record.put("issue_description", rs.getString("issue_description"));
                    record.put("priority", rs.getString("priority"));
                    record.put("status", rs.getString("status"));
                    record.put("estimated_cost", rs.getBigDecimal("estimated_cost"));
                    record.put("actual_cost", rs.getBigDecimal("actual_cost"));
                    record.put("start_date", rs.getTimestamp("start_date"));
                    record.put("completion_date", rs.getTimestamp("completion_date"));
                    records.add(record);
                }
                return records;
            }
        }
    }

    public boolean addMaintenanceRecord(int roomId, String issueDescription, int reportedBy,
            String priority) throws SQLException {
        String sql = "INSERT INTO maintenance_records (room_id, issue_description, reported_by, priority, status) " +
                "VALUES (?, ?, ?, ?, 'reported')";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setString(2, issueDescription);
            ps.setInt(3, reportedBy);
            ps.setString(4, priority);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateMaintenanceStatus(int maintenanceId, String newStatus) throws SQLException {
        String sql = "UPDATE maintenance_records SET status = ? WHERE maintenance_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, maintenanceId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean assignMaintenance(int maintenanceId, int assignedTo) throws SQLException {
        String sql = "UPDATE maintenance_records SET assigned_to = ?, start_date = NOW() WHERE maintenance_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignedTo);
            ps.setInt(2, maintenanceId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean completeMaintenance(int maintenanceId, double actualCost) throws SQLException {
        String sql = "UPDATE maintenance_records SET status = 'completed', actual_cost = ?, completion_date = NOW() WHERE maintenance_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, new java.math.BigDecimal(actualCost));
            ps.setInt(2, maintenanceId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteMaintenanceRecord(int maintenanceId) throws SQLException {
        String sql = "DELETE FROM maintenance_records WHERE maintenance_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            return ps.executeUpdate() == 1;
        }
    }

    public Map<String, Object> getMaintenanceById(int maintenanceId) throws SQLException {
        String sql = "SELECT m.*, r.room_number, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                "FROM maintenance_records m " +
                "JOIN rooms r ON m.room_id = r.room_id " +
                "LEFT JOIN users u1 ON m.reported_by = u1.user_id " +
                "LEFT JOIN users u2 ON m.assigned_to = u2.user_id " +
                "WHERE m.maintenance_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    record.put("maintenance_id", rs.getInt("maintenance_id"));
                    record.put("room_id", rs.getInt("room_id"));
                    record.put("room_number", rs.getString("room_number"));
                    record.put("issue_description", rs.getString("issue_description"));
                    record.put("priority", rs.getString("priority"));
                    record.put("status", rs.getString("status"));
                    record.put("estimated_cost", rs.getBigDecimal("estimated_cost"));
                    record.put("actual_cost", rs.getBigDecimal("actual_cost"));
                    record.put("start_date", rs.getTimestamp("start_date"));
                    record.put("completion_date", rs.getTimestamp("completion_date"));
                    record.put("reported_by_name", rs.getString("reported_by_name"));
                    record.put("assigned_to_name", rs.getString("assigned_to_name"));
                    return record;
                }
            }
        }
        return null;
    }

    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM maintenance_records WHERE status = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }
        return 0;
    }
}
