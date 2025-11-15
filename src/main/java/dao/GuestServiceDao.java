package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GuestServiceDao {

    public List<Map<String, Object>> getAllGuestServices() throws SQLException {
        String sql = "SELECT gs.guest_service_id, gs.booking_id, gs.service_id, gs.quantity, gs.service_date, " +
                "gs.status, b.booking_id, g.first_name, g.last_name, s.service_name, s.price " +
                "FROM guest_services gs " +
                "JOIN bookings b ON gs.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "JOIN services s ON gs.service_id = s.service_id " +
                "ORDER BY gs.service_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> services = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> service = new HashMap<>();
                service.put("guest_service_id", rs.getInt("guest_service_id"));
                service.put("booking_id", rs.getInt("booking_id"));
                service.put("service_id", rs.getInt("service_id"));
                service.put("service_name", rs.getString("service_name"));
                service.put("guest_name", rs.getString("first_name") + " " + rs.getString("last_name"));
                service.put("quantity", rs.getInt("quantity"));
                service.put("price", rs.getBigDecimal("price"));
                service.put("service_date", rs.getTimestamp("service_date"));
                service.put("status", rs.getString("status"));
                services.add(service);
            }
            return services;
        }
    }

    public List<Map<String, Object>> getServicesByBooking(int bookingId) throws SQLException {
        String sql = "SELECT gs.guest_service_id, gs.service_id, gs.quantity, gs.service_date, gs.status, " +
                "s.service_name, s.price, s.description " +
                "FROM guest_services gs " +
                "JOIN services s ON gs.service_id = s.service_id " +
                "WHERE gs.booking_id = ? ORDER BY gs.service_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> services = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> service = new HashMap<>();
                    service.put("guest_service_id", rs.getInt("guest_service_id"));
                    service.put("service_id", rs.getInt("service_id"));
                    service.put("service_name", rs.getString("service_name"));
                    service.put("quantity", rs.getInt("quantity"));
                    service.put("price", rs.getBigDecimal("price"));
                    service.put("description", rs.getString("description"));
                    service.put("service_date", rs.getTimestamp("service_date"));
                    service.put("status", rs.getString("status"));
                    services.add(service);
                }
                return services;
            }
        }
    }

    public List<Map<String, Object>> getServicesByGuest(int guestId) throws SQLException {
        String sql = "SELECT gs.guest_service_id, gs.booking_id, gs.service_id, gs.quantity, gs.service_date, gs.status, "
                +
                "s.service_name, s.price FROM guest_services gs " +
                "JOIN services s ON gs.service_id = s.service_id " +
                "JOIN bookings b ON gs.booking_id = b.booking_id " +
                "WHERE b.guest_id = ? ORDER BY gs.service_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> services = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> service = new HashMap<>();
                    service.put("guest_service_id", rs.getInt("guest_service_id"));
                    service.put("booking_id", rs.getInt("booking_id"));
                    service.put("service_name", rs.getString("service_name"));
                    service.put("quantity", rs.getInt("quantity"));
                    service.put("price", rs.getBigDecimal("price"));
                    service.put("service_date", rs.getTimestamp("service_date"));
                    service.put("status", rs.getString("status"));
                    services.add(service);
                }
                return services;
            }
        }
    }

    public List<Map<String, Object>> getServicesByStatus(String status) throws SQLException {
        String sql = "SELECT gs.guest_service_id, gs.booking_id, gs.service_id, gs.quantity, gs.service_date, " +
                "s.service_name, s.price, g.first_name, g.last_name " +
                "FROM guest_services gs " +
                "JOIN services s ON gs.service_id = s.service_id " +
                "JOIN bookings b ON gs.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "WHERE gs.status = ? ORDER BY gs.service_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> services = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> service = new HashMap<>();
                    service.put("guest_service_id", rs.getInt("guest_service_id"));
                    service.put("booking_id", rs.getInt("booking_id"));
                    service.put("service_name", rs.getString("service_name"));
                    service.put("guest_name", rs.getString("first_name") + " " + rs.getString("last_name"));
                    service.put("quantity", rs.getInt("quantity"));
                    service.put("service_date", rs.getTimestamp("service_date"));
                    service.put("status", status);
                    services.add(service);
                }
                return services;
            }
        }
    }

    public boolean addGuestService(int bookingId, int serviceId, int quantity) throws SQLException {
        String sql = "INSERT INTO guest_services (booking_id, service_id, quantity, service_date, status) " +
                "VALUES (?, ?, ?, NOW(), 'pending')";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, serviceId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateServiceStatus(int guestServiceId, String status) throws SQLException {
        String sql = "UPDATE guest_services SET status = ? WHERE guest_service_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, guestServiceId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateServiceQuantity(int guestServiceId, int newQuantity) throws SQLException {
        String sql = "UPDATE guest_services SET quantity = ? WHERE guest_service_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, guestServiceId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteGuestService(int guestServiceId) throws SQLException {
        String sql = "DELETE FROM guest_services WHERE guest_service_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestServiceId);
            return ps.executeUpdate() == 1;
        }
    }

    public Map<String, Object> getGuestServiceById(int guestServiceId) throws SQLException {
        String sql = "SELECT gs.*, s.service_name, s.price, g.first_name, g.last_name FROM guest_services gs " +
                "JOIN services s ON gs.service_id = s.service_id " +
                "JOIN bookings b ON gs.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "WHERE gs.guest_service_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestServiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> service = new HashMap<>();
                    service.put("guest_service_id", rs.getInt("guest_service_id"));
                    service.put("booking_id", rs.getInt("booking_id"));
                    service.put("service_id", rs.getInt("service_id"));
                    service.put("service_name", rs.getString("service_name"));
                    service.put("quantity", rs.getInt("quantity"));
                    service.put("price", rs.getBigDecimal("price"));
                    service.put("status", rs.getString("status"));
                    service.put("service_date", rs.getTimestamp("service_date"));
                    service.put("guest_name", rs.getString("first_name") + " " + rs.getString("last_name"));
                    return service;
                }
            }
        }
        return null;
    }

    public double getTotalServiceRevenueByBooking(int bookingId) throws SQLException {
        String sql = "SELECT SUM(gs.quantity * s.price) as total FROM guest_services gs " +
                "JOIN services s ON gs.service_id = s.service_id WHERE gs.booking_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Double total = rs.getDouble("total");
                    return total == null ? 0.0 : total;
                }
            }
        }
        return 0.0;
    }

    public double getTotalServiceRevenue() throws SQLException {
        String sql = "SELECT SUM(gs.quantity * s.price) as total FROM guest_services gs " +
                "JOIN services s ON gs.service_id = s.service_id";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Double total = rs.getDouble("total");
                return total == null ? 0.0 : total;
            }
        }
        return 0.0;
    }

    public int countServicesByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM guest_services WHERE status = ?";

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

    public int getTotalGuestServices() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM guest_services";

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
