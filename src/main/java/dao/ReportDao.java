package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDao {

    public Map<String, Object> generateOccupancyReport(String startDate, String endDate) throws SQLException {
        Map<String, Object> report = new HashMap<>();
        
        // Total rooms
        String totalRoomsSql = "SELECT COUNT(*) as total FROM rooms";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(totalRoomsSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                report.put("total_rooms", rs.getInt("total"));
            }
        }
        
        // Occupied rooms during period
        String occupiedSql = "SELECT COUNT(DISTINCT b.room_id) as occupied FROM bookings b " +
                "WHERE b.status = 'checked_in' AND b.check_in_date <= ? AND b.check_out_date >= ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(occupiedSql)) {
            ps.setString(1, endDate);
            ps.setString(2, startDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("occupied_rooms", rs.getInt("occupied"));
                }
            }
        }
        
        // Available rooms
        String availableSql = "SELECT COUNT(*) as available FROM rooms WHERE status = 'available'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(availableSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                report.put("available_rooms", rs.getInt("available"));
            }
        }
        
        // Maintenance rooms
        String maintenanceSql = "SELECT COUNT(*) as maintenance FROM rooms WHERE status = 'maintenance'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(maintenanceSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                report.put("maintenance_rooms", rs.getInt("maintenance"));
            }
        }
        
        report.put("start_date", startDate);
        report.put("end_date", endDate);
        report.put("generated_at", System.currentTimeMillis());
        
        return report;
    }

    public Map<String, Object> generateRevenueReport(String startDate, String endDate) throws SQLException {
        Map<String, Object> report = new HashMap<>();
        
        // Total revenue from bookings
        String bookingRevenueSql = "SELECT COALESCE(SUM(total_amount), 0) as total FROM bookings " +
                "WHERE check_in_date >= ? AND check_out_date <= ? AND status IN ('checked_in', 'checked_out')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(bookingRevenueSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("booking_revenue", rs.getBigDecimal("total"));
                }
            }
        }
        
        // Total revenue from payments
        String paymentRevenueSql = "SELECT COALESCE(SUM(amount), 0) as total FROM payments " +
                "WHERE payment_date >= ? AND payment_date <= ? AND payment_status = 'completed'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(paymentRevenueSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("payment_revenue", rs.getBigDecimal("total"));
                }
            }
        }
        
        // Total revenue from services
        String serviceRevenueSql = "SELECT COALESCE(SUM(gs.quantity * s.price), 0) as total FROM guest_services gs " +
                "JOIN services s ON gs.service_id = s.service_id " +
                "WHERE gs.service_date >= ? AND gs.service_date <= ? AND gs.status = 'delivered'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(serviceRevenueSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("service_revenue", rs.getBigDecimal("total"));
                }
            }
        }
        
        // Payment breakdown by type
        String paymentTypeSql = "SELECT payment_type, COUNT(*) as count, COALESCE(SUM(amount), 0) as total " +
                "FROM payments WHERE payment_date >= ? AND payment_date <= ? GROUP BY payment_type";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(paymentTypeSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> paymentTypes = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> type = new HashMap<>();
                    type.put("payment_type", rs.getString("payment_type"));
                    type.put("count", rs.getInt("count"));
                    type.put("total", rs.getBigDecimal("total"));
                    paymentTypes.add(type);
                }
                report.put("payment_breakdown", paymentTypes);
            }
        }
        
        report.put("start_date", startDate);
        report.put("end_date", endDate);
        report.put("generated_at", System.currentTimeMillis());
        
        return report;
    }

    public Map<String, Object> generateGuestAnalysis(String startDate, String endDate) throws SQLException {
        Map<String, Object> report = new HashMap<>();
        
        // Total guests
        String totalGuestsSql = "SELECT COUNT(DISTINCT g.guest_id) as total FROM guests g " +
                "JOIN bookings b ON g.guest_id = b.guest_id " +
                "WHERE b.check_in_date >= ? AND b.check_out_date <= ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(totalGuestsSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("total_guests", rs.getInt("total"));
                }
            }
        }
        
        // New guests
        String newGuestsSql = "SELECT COUNT(*) as total FROM guests WHERE created_at >= ? AND created_at <= ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(newGuestsSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("new_guests", rs.getInt("total"));
                }
            }
        }
        
        // Average stay duration
        String avgStaySql = "SELECT AVG(DATEDIFF(b.check_out_date, b.check_in_date)) as avg_days FROM bookings b " +
                "WHERE b.check_in_date >= ? AND b.check_out_date <= ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(avgStaySql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("average_stay_days", rs.getDouble("avg_days"));
                }
            }
        }
        
        // Guest nationalities
        String nationalitySql = "SELECT nationality, COUNT(*) as count FROM guests g " +
                "JOIN bookings b ON g.guest_id = b.guest_id " +
                "WHERE b.check_in_date >= ? AND b.check_out_date <= ? GROUP BY nationality ORDER BY count DESC LIMIT 10";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(nationalitySql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> nationalities = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> nat = new HashMap<>();
                    nat.put("nationality", rs.getString("nationality"));
                    nat.put("count", rs.getInt("count"));
                    nationalities.add(nat);
                }
                report.put("top_nationalities", nationalities);
            }
        }
        
        report.put("start_date", startDate);
        report.put("end_date", endDate);
        report.put("generated_at", System.currentTimeMillis());
        
        return report;
    }

    public Map<String, Object> generateMaintenanceReport(String startDate, String endDate) throws SQLException {
        Map<String, Object> report = new HashMap<>();
        
        // Total maintenance records
        String totalSql = "SELECT COUNT(*) as total FROM maintenance_records " +
                "WHERE created_at >= ? AND created_at <= ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(totalSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("total_records", rs.getInt("total"));
                }
            }
        }
        
        // Maintenance by status
        String statusSql = "SELECT status, COUNT(*) as count FROM maintenance_records " +
                "WHERE created_at >= ? AND created_at <= ? GROUP BY status";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(statusSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                Map<String, Integer> statusBreakdown = new HashMap<>();
                while (rs.next()) {
                    statusBreakdown.put(rs.getString("status"), rs.getInt("count"));
                }
                report.put("status_breakdown", statusBreakdown);
            }
        }
        
        // Maintenance by priority
        String prioritySql = "SELECT priority, COUNT(*) as count FROM maintenance_records " +
                "WHERE created_at >= ? AND created_at <= ? GROUP BY priority";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(prioritySql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                Map<String, Integer> priorityBreakdown = new HashMap<>();
                while (rs.next()) {
                    priorityBreakdown.put(rs.getString("priority"), rs.getInt("count"));
                }
                report.put("priority_breakdown", priorityBreakdown);
            }
        }
        
        // Total maintenance cost
        String costSql = "SELECT COALESCE(SUM(actual_cost), 0) as total FROM maintenance_records " +
                "WHERE completion_date >= ? AND completion_date <= ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(costSql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.put("total_cost", rs.getBigDecimal("total"));
                }
            }
        }
        
        report.put("start_date", startDate);
        report.put("end_date", endDate);
        report.put("generated_at", System.currentTimeMillis());
        
        return report;
    }

    public Map<String, Object> generateInventoryReport() throws SQLException {
        Map<String, Object> report = new HashMap<>();
        
        // Total inventory value
        String valueSql = "SELECT COALESCE(SUM(current_stock * unit_price), 0) as total FROM inventory";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(valueSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                report.put("total_inventory_value", rs.getBigDecimal("total"));
            }
        }
        
        // Total items
        String totalItemsSql = "SELECT COUNT(*) as total FROM inventory";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(totalItemsSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                report.put("total_items", rs.getInt("total"));
            }
        }
        
        // Low stock items
        String lowStockSql = "SELECT item_id, item_name, category, current_stock, minimum_stock FROM inventory " +
                "WHERE current_stock <= minimum_stock ORDER BY current_stock ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(lowStockSql);
             ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> lowStockItems = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("item_id", rs.getInt("item_id"));
                item.put("item_name", rs.getString("item_name"));
                item.put("category", rs.getString("category"));
                item.put("current_stock", rs.getInt("current_stock"));
                item.put("minimum_stock", rs.getInt("minimum_stock"));
                lowStockItems.add(item);
            }
            report.put("low_stock_items", lowStockItems);
        }
        
        // Inventory by category
        String categorySql = "SELECT category, COUNT(*) as count, COALESCE(SUM(current_stock), 0) as total_stock " +
                "FROM inventory GROUP BY category";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(categorySql);
             ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> categories = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> cat = new HashMap<>();
                cat.put("category", rs.getString("category"));
                cat.put("item_count", rs.getInt("count"));
                cat.put("total_stock", rs.getInt("total_stock"));
                categories.add(cat);
            }
            report.put("inventory_by_category", categories);
        }
        
        report.put("generated_at", System.currentTimeMillis());
        
        return report;
    }
}
