package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RoomDao {

    public List<Map<String, Object>> getAllRooms() throws SQLException {
        String sql = "SELECT r.room_id, r.room_number, rt.type_name, rt.base_price, r.status, r.floor_number " +
                "FROM rooms r JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "ORDER BY r.room_number";
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
                room.put("status", rs.getString("status"));
                room.put("floor_number", rs.getInt("floor_number"));
                rooms.add(room);
            }
            return rooms;
        }
    }

    public List<Map<String, Object>> getRoomTypes() throws SQLException {
        String sql = "SELECT room_type_id, type_name, base_price, max_occupancy FROM room_types WHERE is_active = TRUE ORDER BY type_name";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> types = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> type = new HashMap<>();
                type.put("room_type_id", rs.getInt("room_type_id"));
                type.put("type_name", rs.getString("type_name"));
                type.put("base_price", rs.getBigDecimal("base_price"));
                type.put("max_occupancy", rs.getInt("max_occupancy"));
                types.add(type);
            }
            return types;
        }
    }

    public boolean addRoom(String roomNumber, int roomTypeId, int floorNumber) throws SQLException {
        String sql = "INSERT INTO rooms (room_number, room_type_id, floor_number, status) VALUES (?, ?, ?, 'available')";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roomNumber);
            ps.setInt(2, roomTypeId);
            ps.setInt(3, floorNumber);
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

    public boolean deleteRoom(int roomId) throws SQLException {
        String sql = "DELETE FROM rooms WHERE room_id = ? AND status = 'available'";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() == 1;
        }
    }

    public Map<String, Object> getRoomDetailsWithBooking(int roomId) throws SQLException {
        String sql = "SELECT r.room_id, r.room_number, rt.type_name, rt.base_price, rt.max_occupancy, r.status, r.floor_number, "
                +
                "b.booking_id, b.guest_id, g.first_name, g.last_name, g.email, g.phone, g.id_number, " +
                "b.check_in_date, b.check_out_date, b.adults, b.children, b.total_amount, b.status as booking_status " +
                "FROM rooms r " +
                "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "LEFT JOIN bookings b ON r.room_id = b.room_id AND (b.status = 'confirmed' OR b.status = 'checked_in') "
                +
                "LEFT JOIN guests g ON b.guest_id = g.guest_id " +
                "WHERE r.room_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> room = new HashMap<>();
                    room.put("room_id", rs.getInt("room_id"));
                    room.put("room_number", rs.getString("room_number"));
                    room.put("type_name", rs.getString("type_name"));
                    room.put("base_price", rs.getBigDecimal("base_price"));
                    room.put("max_occupancy", rs.getInt("max_occupancy"));
                    room.put("status", rs.getString("status"));
                    room.put("floor_number", rs.getInt("floor_number"));

                    // Booking information (if occupied)
                    int bookingId = rs.getInt("booking_id");
                    if (bookingId > 0) {
                        Map<String, Object> booking = new HashMap<>();
                        booking.put("booking_id", bookingId);
                        booking.put("guest_id", rs.getInt("guest_id"));
                        booking.put("first_name", rs.getString("first_name"));
                        booking.put("last_name", rs.getString("last_name"));
                        booking.put("email", rs.getString("email"));
                        booking.put("phone", rs.getString("phone"));
                        booking.put("id_number", rs.getString("id_number"));
                        booking.put("check_in_date", rs.getDate("check_in_date"));
                        booking.put("check_out_date", rs.getDate("check_out_date"));
                        booking.put("adults", rs.getInt("adults"));
                        booking.put("children", rs.getInt("children"));
                        booking.put("total_amount", rs.getBigDecimal("total_amount"));
                        booking.put("booking_status", rs.getString("booking_status"));
                        room.put("booking", booking);
                    } else {
                        room.put("booking", null);
                    }

                    return room;
                }
            }
        }
        return null;
    }
}
