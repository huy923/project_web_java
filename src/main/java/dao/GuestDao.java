package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GuestDao {
    
    public List<Map<String, Object>> getAllGuests() throws SQLException {
        String sql = "SELECT g.guest_id, g.first_name, g.last_name, g.email, g.phone, g.id_number, " +
                    "g.nationality, g.created_at, b.room_id, r.room_number, b.status as booking_status " +
                    "FROM guests g " +
                    "LEFT JOIN bookings b ON g.guest_id = b.guest_id AND b.status = 'checked_in' " +
                    "LEFT JOIN rooms r ON b.room_id = r.room_id " +
                    "ORDER BY g.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> guests = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> guest = new HashMap<>();
                guest.put("guest_id", rs.getInt("guest_id"));
                guest.put("first_name", rs.getString("first_name"));
                guest.put("last_name", rs.getString("last_name"));
                guest.put("email", rs.getString("email"));
                guest.put("phone", rs.getString("phone"));
                guest.put("id_number", rs.getString("id_number"));
                guest.put("nationality", rs.getString("nationality"));
                guest.put("created_at", rs.getTimestamp("created_at"));
                guest.put("room_id", rs.getObject("room_id"));
                guest.put("room_number", rs.getString("room_number"));
                guest.put("booking_status", rs.getString("booking_status"));
                guests.add(guest);
            }
            return guests;
        }
    }
    
    public boolean addGuest(String firstName, String lastName, String email, String phone, 
                           String idNumber, String nationality) throws SQLException {
        String sql = "INSERT INTO guests (first_name, last_name, email, phone, id_number, nationality) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, idNumber);
            ps.setString(6, nationality);
            return ps.executeUpdate() == 1;
        }
    }
    
    public boolean updateGuest(int guestId, String firstName, String lastName, String email, 
                              String phone, String idNumber, String nationality) throws SQLException {
        String sql = "UPDATE guests SET first_name = ?, last_name = ?, email = ?, phone = ?, " +
                    "id_number = ?, nationality = ? WHERE guest_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, idNumber);
            ps.setString(6, nationality);
            ps.setInt(7, guestId);
            return ps.executeUpdate() == 1;
        }
    }
    
    public boolean deleteGuest(int guestId) throws SQLException {
        // Only delete if guest has no active bookings
        String sql = "DELETE FROM guests WHERE guest_id = ? AND guest_id NOT IN " +
                    "(SELECT DISTINCT guest_id FROM bookings WHERE status IN ('confirmed', 'checked_in'))";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            return ps.executeUpdate() == 1;
        }
    }
    
    public Map<String, Object> getGuestById(int guestId) throws SQLException {
        String sql = "SELECT * FROM guests WHERE guest_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> guest = new HashMap<>();
                    guest.put("guest_id", rs.getInt("guest_id"));
                    guest.put("first_name", rs.getString("first_name"));
                    guest.put("last_name", rs.getString("last_name"));
                    guest.put("email", rs.getString("email"));
                    guest.put("phone", rs.getString("phone"));
                    guest.put("id_number", rs.getString("id_number"));
                    guest.put("nationality", rs.getString("nationality"));
                    guest.put("address", rs.getString("address"));
                    guest.put("date_of_birth", rs.getDate("date_of_birth"));
                    return guest;
                }
            }
        }
        return null;
    }
}
