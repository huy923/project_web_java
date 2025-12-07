package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookingDao {

    public List<Map<String, Object>> getAvailableRooms() throws SQLException {
        String sql = "SELECT r.room_id, r.room_number, rt.type_name, rt.base_price FROM rooms r " +
                "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "WHERE r.status = 'available' ORDER BY r.room_number";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> rooms = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("room_id", rs.getInt("room_id"));
                room.put("room_number", rs.getString("room_number"));
                room.put("type_name", rs.getString("type_name"));
                room.put("base_price", rs.getBigDecimal("base_price"));
                rooms.add(room);
            }
            return rooms;
        }
    }

    public List<Map<String, Object>> getOccupiedRooms() throws SQLException {
        String sql = "SELECT b.booking_id, r.room_number, g.first_name, g.last_name, g.phone, " +
                "b.check_in_date, b.check_out_date, b.total_amount " +
                "FROM bookings b " +
                "JOIN rooms r ON b.room_id = r.room_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "WHERE b.status = 'checked_in' ORDER BY r.room_number";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> bookings = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("room_number", rs.getString("room_number"));
                booking.put("first_name", rs.getString("first_name"));
                booking.put("last_name", rs.getString("last_name"));
                booking.put("phone", rs.getString("phone"));
                booking.put("check_in_date", rs.getDate("check_in_date"));
                booking.put("check_out_date", rs.getDate("check_out_date"));
                booking.put("total_amount", rs.getBigDecimal("total_amount"));
                bookings.add(booking);
            }
            return bookings;
        }
    }

    public boolean createGuest(String firstName, String lastName, String email, String phone, String idNumber)
            throws SQLException {
        String sql = "INSERT INTO guests (first_name, last_name, email, phone, id_number) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, idNumber);
            return ps.executeUpdate() == 1;
        }
    }

    public int getGuestId(String phone) throws SQLException {
        String sql = "SELECT guest_id FROM guests WHERE phone = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("guest_id");
                }
            }
        }
        return -1;
    }

    public boolean createBooking(int guestId, int roomId, Date checkInDate, Date checkOutDate,
            int adults, int children, double totalAmount, int createdBy) throws SQLException {
        String sql = "INSERT INTO bookings (guest_id, room_id, check_in_date, check_out_date, " +
                "adults, children, total_amount, status, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, 'checked_in', ?)";
        try (Connection conn = DatabaseConnection.getConnection(); 
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            ps.setInt(2, roomId);
            ps.setDate(3, checkInDate);
            ps.setDate(4, checkOutDate);
            ps.setInt(5, adults);
            ps.setInt(6, children);
            ps.setBigDecimal(7, new java.math.BigDecimal(totalAmount));
            ps.setInt(8, createdBy);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateRoomStatus(int roomId, String status) throws SQLException {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, roomId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean checkoutBooking(int bookingId) throws SQLException {
        String sql = "UPDATE bookings SET status = 'checked_out' WHERE booking_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() == 1;
        }
    }

    public int getRoomIdByBooking(int bookingId) throws SQLException {
        String sql = "SELECT room_id FROM bookings WHERE booking_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("room_id");
                }
            }
        }
        return -1;
    }

    public List<Map<String, Object>> getAllBookings() throws SQLException {
        String sql = """
                SELECT b.booking_id, b.guest_id, b.room_id, b.check_in_date, b.check_out_date,
                       b.total_amount, b.status, b.adults, b.children, b.created_at,
                       g.first_name, g.last_name, g.phone, g.email, g.id_number,
                       r.room_number, rt.type_name, rt.base_price
                FROM bookings b
                JOIN guests g ON b.guest_id = g.guest_id
                JOIN rooms r ON b.room_id = r.room_id
                JOIN room_types rt ON r.room_type_id = rt.room_type_id
                ORDER BY b.created_at DESC;""";
        
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> bookings = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("guest_id", rs.getInt("guest_id"));
                booking.put("room_id", rs.getInt("room_id"));
                booking.put("check_in_date", rs.getDate("check_in_date"));
                booking.put("check_out_date", rs.getDate("check_out_date"));
                booking.put("total_amount", rs.getBigDecimal("total_amount"));
                booking.put("status", rs.getString("status"));
                booking.put("adults", rs.getInt("adults"));
                booking.put("children", rs.getInt("children"));
                booking.put("created_at", rs.getTimestamp("created_at"));
                
                // Guest information
                booking.put("first_name", rs.getString("first_name"));
                booking.put("last_name", rs.getString("last_name"));
                booking.put("phone", rs.getString("phone"));
                booking.put("email", rs.getString("email"));
                booking.put("id_number", rs.getString("id_number"));
                
                // Room information
                booking.put("room_number", rs.getString("room_number"));
                booking.put("type_name", rs.getString("type_name"));
                booking.put("base_price", rs.getBigDecimal("base_price"));
                
                bookings.add(booking);
            }
            return bookings;
        }
    }

    public boolean createBookingConfirmed(int guestId, int roomId, Date checkInDate, Date checkOutDate,
            int adults, int children, double totalAmount, int createdBy) throws SQLException {
        String sql = "INSERT INTO bookings (guest_id, room_id, check_in_date, check_out_date, " +
                "adults, children, total_amount, status, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, 'confirmed', ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            ps.setInt(2, roomId);
            ps.setDate(3, checkInDate);
            ps.setDate(4, checkOutDate);
            ps.setInt(5, adults);
            ps.setInt(6, children);
            ps.setBigDecimal(7, new java.math.BigDecimal(totalAmount));
            ps.setInt(8, createdBy);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ?, updated_at = NOW() WHERE booking_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateBooking(int bookingId, Date checkInDate, Date checkOutDate, 
            int adults, int children) throws SQLException {
        String sql = "UPDATE bookings SET check_in_date = ?, check_out_date = ?, adults = ?, " +
                    "children = ?, updated_at = NOW() WHERE booking_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, checkInDate);
            ps.setDate(2, checkOutDate);
            ps.setInt(3, adults);
            ps.setInt(4, children);
            ps.setInt(5, bookingId);
            return ps.executeUpdate() == 1;
        }
    }

    public double calculateTotalAmount(int roomId, Date checkInDate, Date checkOutDate) throws SQLException {
        // Get room base price
        String sql = "SELECT rt.base_price FROM rooms r " +
                    "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                    "WHERE r.room_id = ?";
        
        double basePrice;
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    basePrice = rs.getBigDecimal("base_price").doubleValue();
                } else {
                    throw new SQLException("Room not found");
                }
            }
        }
        
        // Calculate nights
        long diffInMillies = checkOutDate.getTime() - checkInDate.getTime();
        int nights = (int) (diffInMillies / (1000 * 60 * 60 * 24));
        if (nights <= 0) nights = 1;
        
        // Calculate total
        return basePrice * nights;
    }

    public Map<String, Object> getBookingById(int bookingId) throws SQLException {
        String sql = "SELECT b.*, g.first_name, g.last_name, g.phone, g.email, g.id_number, " +
                    "r.room_number, rt.type_name, rt.base_price " +
                    "FROM bookings b " +
                    "JOIN guests g ON b.guest_id = g.guest_id " +
                    "JOIN rooms r ON b.room_id = r.room_id " +
                    "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                    "WHERE b.booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("booking_id", rs.getInt("booking_id"));
                    booking.put("guest_id", rs.getInt("guest_id"));
                    booking.put("room_id", rs.getInt("room_id"));
                    booking.put("check_in_date", rs.getDate("check_in_date"));
                    booking.put("check_out_date", rs.getDate("check_out_date"));
                    booking.put("total_amount", rs.getBigDecimal("total_amount"));
                    booking.put("status", rs.getString("status"));
                    booking.put("adults", rs.getInt("adults"));
                    booking.put("children", rs.getInt("children"));
                    booking.put("created_at", rs.getTimestamp("created_at"));
                    booking.put("updated_at", rs.getTimestamp("updated_at"));
                    
                    // Guest information
                    booking.put("first_name", rs.getString("first_name"));
                    booking.put("last_name", rs.getString("last_name"));
                    booking.put("phone", rs.getString("phone"));
                    booking.put("email", rs.getString("email"));
                    booking.put("id_number", rs.getString("id_number"));
                    
                    // Room information
                    booking.put("room_number", rs.getString("room_number"));
                    booking.put("type_name", rs.getString("type_name"));
                    booking.put("base_price", rs.getBigDecimal("base_price"));
                    
                    return booking;
                }
            }
        }
        return null;
    }
}
