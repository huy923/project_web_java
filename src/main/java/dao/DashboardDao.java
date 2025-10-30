package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.DatabaseConnection;

public class DashboardDao {
    public List<Map<String, Object>> getCurrentRoomStatus() throws SQLException {
        String sql = "SELECT room_id, room_number, type_name, base_price, status, first_name, last_name, phone, check_in_date, check_out_date FROM current_room_status ORDER BY room_number";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> list = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("room_id", rs.getInt("room_id"));
                m.put("room_number", rs.getString("room_number"));
                m.put("type_name", rs.getString("type_name"));
                m.put("base_price", rs.getBigDecimal("base_price"));
                m.put("status", rs.getString("status"));
                m.put("first_name", rs.getString("first_name"));
                m.put("last_name", rs.getString("last_name"));
                m.put("phone", rs.getString("phone"));
                m.put("check_in_date", rs.getDate("check_in_date"));
                m.put("check_out_date", rs.getDate("check_out_date"));
                list.add(m);
            }
            return list;
        }
    }

    public Map<String, Integer> getRoomStatistics() throws SQLException {
        String sql = "SELECT status, COUNT(*) as count FROM rooms GROUP BY status";
        Map<String, Integer> stats = new HashMap<>();
        stats.put("available", 0);
        stats.put("occupied", 0);
        stats.put("maintenance", 0);
        stats.put("cleaning", 0);

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                stats.put(status, count);
            }
        }
        return stats;
    }
    public int getTotalBookings() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM bookings WHERE status IN ('confirmed', 'checked_in', 'checked_out')";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
}
