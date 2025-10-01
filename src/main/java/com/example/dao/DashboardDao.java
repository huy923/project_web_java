package com.example.dao;

import com.example.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
}
