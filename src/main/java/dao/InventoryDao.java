package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InventoryDao {

    public List<Map<String, Object>> getAllInventory() throws SQLException {
        String sql = "SELECT item_id, item_name, category, current_stock, minimum_stock, unit_price, supplier, last_restocked, created_at "
                +
                "FROM inventory ORDER BY item_name";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> items = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("item_id", rs.getInt("item_id"));
                item.put("item_name", rs.getString("item_name"));
                item.put("category", rs.getString("category"));
                item.put("current_stock", rs.getInt("current_stock"));
                item.put("minimum_stock", rs.getInt("minimum_stock"));
                item.put("unit_price", rs.getBigDecimal("unit_price"));
                item.put("supplier", rs.getString("supplier"));
                item.put("last_restocked", rs.getTimestamp("last_restocked"));
                item.put("created_at", rs.getTimestamp("created_at"));
                items.add(item);
            }
            return items;
        }
    }

    public List<Map<String, Object>> getInventoryByCategory(String category) throws SQLException {
        String sql = "SELECT * FROM inventory WHERE category = ? ORDER BY item_name";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> items = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("item_id", rs.getInt("item_id"));
                    item.put("item_name", rs.getString("item_name"));
                    item.put("category", rs.getString("category"));
                    item.put("current_stock", rs.getInt("current_stock"));
                    item.put("minimum_stock", rs.getInt("minimum_stock"));
                    item.put("unit_price", rs.getBigDecimal("unit_price"));
                    item.put("supplier", rs.getString("supplier"));
                    items.add(item);
                }
                return items;
            }
        }
    }

    public List<Map<String, Object>> getLowStockItems() throws SQLException {
        String sql = "SELECT * FROM inventory WHERE current_stock <= minimum_stock ORDER BY current_stock ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> items = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("item_id", rs.getInt("item_id"));
                item.put("item_name", rs.getString("item_name"));
                item.put("category", rs.getString("category"));
                item.put("current_stock", rs.getInt("current_stock"));
                item.put("minimum_stock", rs.getInt("minimum_stock"));
                item.put("unit_price", rs.getBigDecimal("unit_price"));
                items.add(item);
            }
            return items;
        }
    }

    public boolean addInventoryItem(String itemName, String category, int currentStock,
            int minimumStock, double unitPrice, String supplier) throws SQLException {
        String sql = "INSERT INTO inventory (item_name, category, current_stock, minimum_stock, unit_price, supplier) "
                +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, itemName);
            ps.setString(2, category);
            ps.setInt(3, currentStock);
            ps.setInt(4, minimumStock);
            ps.setBigDecimal(5, new java.math.BigDecimal(unitPrice));
            ps.setString(6, supplier);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateInventoryStock(int itemId, int newStock) throws SQLException {
        String sql = "UPDATE inventory SET current_stock = ?, last_restocked = NOW() WHERE item_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newStock);
            ps.setInt(2, itemId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean addStock(int itemId, int quantity) throws SQLException {
        String sql = "UPDATE inventory SET current_stock = current_stock + ?, last_restocked = NOW() WHERE item_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, itemId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean removeStock(int itemId, int quantity) throws SQLException {
        String sql = "UPDATE inventory SET current_stock = GREATEST(0, current_stock - ?) WHERE item_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, itemId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteInventoryItem(int itemId) throws SQLException {
        String sql = "DELETE FROM inventory WHERE item_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() == 1;
        }
    }

    public Map<String, Object> getInventoryById(int itemId) throws SQLException {
        String sql = "SELECT * FROM inventory WHERE item_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("item_id", rs.getInt("item_id"));
                    item.put("item_name", rs.getString("item_name"));
                    item.put("category", rs.getString("category"));
                    item.put("current_stock", rs.getInt("current_stock"));
                    item.put("minimum_stock", rs.getInt("minimum_stock"));
                    item.put("unit_price", rs.getBigDecimal("unit_price"));
                    item.put("supplier", rs.getString("supplier"));
                    item.put("last_restocked", rs.getTimestamp("last_restocked"));
                    return item;
                }
            }
        }
        return null;
    }

    public int countTotalItems() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM inventory";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    public int countLowStockItems() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM inventory WHERE current_stock <= minimum_stock";

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
