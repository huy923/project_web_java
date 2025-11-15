package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ServiceDao {

    public List<Map<String, Object>> getAllServices() throws SQLException {
        String sql = "SELECT service_id, service_name, description, price, category, is_active, created_at " +
                "FROM services WHERE is_active = TRUE ORDER BY service_name";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> services = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> service = new HashMap<>();
                service.put("service_id", rs.getInt("service_id"));
                service.put("service_name", rs.getString("service_name"));
                service.put("description", rs.getString("description"));
                service.put("price", rs.getBigDecimal("price"));
                service.put("category", rs.getString("category"));
                service.put("is_active", rs.getBoolean("is_active"));
                service.put("created_at", rs.getTimestamp("created_at"));
                services.add(service);
            }
            return services;
        }
    }

    public List<Map<String, Object>> getServicesByCategory(String category) throws SQLException {
        String sql = "SELECT service_id, service_name, description, price, category, is_active, created_at " +
                "FROM services WHERE category = ? AND is_active = TRUE ORDER BY service_name";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> services = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> service = new HashMap<>();
                    service.put("service_id", rs.getInt("service_id"));
                    service.put("service_name", rs.getString("service_name"));
                    service.put("description", rs.getString("description"));
                    service.put("price", rs.getBigDecimal("price"));
                    service.put("category", rs.getString("category"));
                    service.put("is_active", rs.getBoolean("is_active"));
                    services.add(service);
                }
                return services;
            }
        }
    }

    public boolean addService(String serviceName, String description, double price,
            String category) throws SQLException {
        String sql = "INSERT INTO services (service_name, description, price, category, is_active) " +
                "VALUES (?, ?, ?, ?, TRUE)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, serviceName);
            ps.setString(2, description);
            ps.setBigDecimal(3, new java.math.BigDecimal(price));
            ps.setString(4, category);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateService(int serviceId, String serviceName, String description,
            double price, String category) throws SQLException {
        String sql = "UPDATE services SET service_name = ?, description = ?, price = ?, category = ? WHERE service_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, serviceName);
            ps.setString(2, description);
            ps.setBigDecimal(3, new java.math.BigDecimal(price));
            ps.setString(4, category);
            ps.setInt(5, serviceId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteService(int serviceId) throws SQLException {
        String sql = "UPDATE services SET is_active = FALSE WHERE service_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            return ps.executeUpdate() == 1;
        }
    }

    public Map<String, Object> getServiceById(int serviceId) throws SQLException {
        String sql = "SELECT * FROM services WHERE service_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> service = new HashMap<>();
                    service.put("service_id", rs.getInt("service_id"));
                    service.put("service_name", rs.getString("service_name"));
                    service.put("description", rs.getString("description"));
                    service.put("price", rs.getBigDecimal("price"));
                    service.put("category", rs.getString("category"));
                    service.put("is_active", rs.getBoolean("is_active"));
                    return service;
                }
            }
        }
        return null;
    }

    public int countServices() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM services WHERE is_active = TRUE";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    public double getTotalRevenueFromServices() throws SQLException {
        String sql = "SELECT COALESCE(SUM(gs.total_price), 0) as total FROM guest_services gs WHERE gs.status = 'delivered'";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("total");
            }
        }
        return 0.0;
    }
}
