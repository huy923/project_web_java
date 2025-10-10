package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PaymentDao {

    public List<Map<String, Object>> getAllPayments() throws SQLException {
        String sql = "SELECT p.payment_id, p.booking_id, p.amount, p.payment_type, p.payment_status, " +
                "p.transaction_id, p.payment_date, p.processed_by, p.notes, " +
                "g.first_name, g.last_name, g.phone, " +
                "r.room_number, rt.type_name, " +
                "u.full_name as processed_by_name " +
                "FROM payments p " +
                "JOIN bookings b ON p.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "JOIN rooms r ON b.room_id = r.room_id " +
                "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "LEFT JOIN users u ON p.processed_by = u.user_id " +
                "ORDER BY p.payment_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> payments = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> payment = new HashMap<>();
                payment.put("payment_id", rs.getInt("payment_id"));
                payment.put("booking_id", rs.getInt("booking_id"));
                payment.put("amount", rs.getBigDecimal("amount"));
                payment.put("payment_type", rs.getString("payment_type"));
                payment.put("payment_status", rs.getString("payment_status"));
                payment.put("transaction_id", rs.getString("transaction_id"));
                payment.put("payment_date", rs.getTimestamp("payment_date"));
                payment.put("processed_by", rs.getInt("processed_by"));
                payment.put("notes", rs.getString("notes"));

                // Guest information
                payment.put("first_name", rs.getString("first_name"));
                payment.put("last_name", rs.getString("last_name"));
                payment.put("phone", rs.getString("phone"));

                // Room information
                payment.put("room_number", rs.getString("room_number"));
                payment.put("type_name", rs.getString("type_name"));

                // Processed by user
                payment.put("processed_by_name", rs.getString("processed_by_name"));

                payments.add(payment);
            }
            return payments;
        }
    }

    public List<Map<String, Object>> getPaymentsByStatus(String status) throws SQLException {
        String sql = "SELECT p.payment_id, p.booking_id, p.amount, p.payment_type, p.payment_status, " +
                "p.transaction_id, p.payment_date, p.processed_by, p.notes, " +
                "g.first_name, g.last_name, g.phone, " +
                "r.room_number, rt.type_name, " +
                "u.full_name as processed_by_name " +
                "FROM payments p " +
                "JOIN bookings b ON p.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "JOIN rooms r ON b.room_id = r.room_id " +
                "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "LEFT JOIN users u ON p.processed_by = u.user_id " +
                "WHERE p.payment_status = ? " +
                "ORDER BY p.payment_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> payments = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> payment = new HashMap<>();
                    payment.put("payment_id", rs.getInt("payment_id"));
                    payment.put("booking_id", rs.getInt("booking_id"));
                    payment.put("amount", rs.getBigDecimal("amount"));
                    payment.put("payment_type", rs.getString("payment_type"));
                    payment.put("payment_status", rs.getString("payment_status"));
                    payment.put("transaction_id", rs.getString("transaction_id"));
                    payment.put("payment_date", rs.getTimestamp("payment_date"));
                    payment.put("processed_by", rs.getInt("processed_by"));
                    payment.put("notes", rs.getString("notes"));

                    // Guest information
                    payment.put("first_name", rs.getString("first_name"));
                    payment.put("last_name", rs.getString("last_name"));
                    payment.put("phone", rs.getString("phone"));

                    // Room information
                    payment.put("room_number", rs.getString("room_number"));
                    payment.put("type_name", rs.getString("type_name"));

                    // Processed by user
                    payment.put("processed_by_name", rs.getString("processed_by_name"));

                    payments.add(payment);
                }
                return payments;
            }
        }
    }

    public Map<String, Object> getPaymentById(int paymentId) throws SQLException {
        String sql = "SELECT p.payment_id, p.booking_id, p.amount, p.payment_type, p.payment_status, " +
                "p.transaction_id, p.payment_date, p.processed_by, p.notes, " +
                "g.first_name, g.last_name, g.phone, g.email, " +
                "r.room_number, rt.type_name, " +
                "u.full_name as processed_by_name " +
                "FROM payments p " +
                "JOIN bookings b ON p.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "JOIN rooms r ON b.room_id = r.room_id " +
                "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "LEFT JOIN users u ON p.processed_by = u.user_id " +
                "WHERE p.payment_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> payment = new HashMap<>();
                    payment.put("payment_id", rs.getInt("payment_id"));
                    payment.put("booking_id", rs.getInt("booking_id"));
                    payment.put("amount", rs.getBigDecimal("amount"));
                    payment.put("payment_type", rs.getString("payment_type"));
                    payment.put("payment_status", rs.getString("payment_status"));
                    payment.put("transaction_id", rs.getString("transaction_id"));
                    payment.put("payment_date", rs.getTimestamp("payment_date"));
                    payment.put("processed_by", rs.getInt("processed_by"));
                    payment.put("notes", rs.getString("notes"));

                    // Guest information
                    payment.put("first_name", rs.getString("first_name"));
                    payment.put("last_name", rs.getString("last_name"));
                    payment.put("phone", rs.getString("phone"));
                    payment.put("email", rs.getString("email"));

                    // Room information
                    payment.put("room_number", rs.getString("room_number"));
                    payment.put("type_name", rs.getString("type_name"));

                    // Processed by user
                    payment.put("processed_by_name", rs.getString("processed_by_name"));

                    return payment;
                }
            }
        }
        return null;
    }

    public boolean createPayment(int bookingId, double amount, String paymentType,
            String transactionId, int processedBy, String notes) throws SQLException {
        String sql = "INSERT INTO payments (booking_id, amount, payment_type, transaction_id, processed_by, notes) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setBigDecimal(2, new java.math.BigDecimal(amount));
            ps.setString(3, paymentType);
            ps.setString(4, transactionId);
            ps.setInt(5, processedBy);
            ps.setString(6, notes);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updatePaymentStatus(int paymentId, String status) throws SQLException {
        String sql = "UPDATE payments SET payment_status = ? WHERE payment_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, paymentId);
            return ps.executeUpdate() == 1;
        }
    }

    public List<Map<String, Object>> getPaymentsByBooking(int bookingId) throws SQLException {
        String sql = "SELECT p.payment_id, p.booking_id, p.amount, p.payment_type, p.payment_status, " +
                "p.transaction_id, p.payment_date, p.processed_by, p.notes, " +
                "u.full_name as processed_by_name " +
                "FROM payments p " +
                "LEFT JOIN users u ON p.processed_by = u.user_id " +
                "WHERE p.booking_id = ? " +
                "ORDER BY p.payment_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> payments = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> payment = new HashMap<>();
                    payment.put("payment_id", rs.getInt("payment_id"));
                    payment.put("booking_id", rs.getInt("booking_id"));
                    payment.put("amount", rs.getBigDecimal("amount"));
                    payment.put("payment_type", rs.getString("payment_type"));
                    payment.put("payment_status", rs.getString("payment_status"));
                    payment.put("transaction_id", rs.getString("transaction_id"));
                    payment.put("payment_date", rs.getTimestamp("payment_date"));
                    payment.put("processed_by", rs.getInt("processed_by"));
                    payment.put("notes", rs.getString("notes"));
                    payment.put("processed_by_name", rs.getString("processed_by_name"));

                    payments.add(payment);
                }
                return payments;
            }
        }
    }

    public double getTotalPaidByBooking(int bookingId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) as total_paid FROM payments " +
                "WHERE booking_id = ? AND payment_status = 'completed'";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total_paid");
                }
            }
        }
        return 0.0;
    }
}