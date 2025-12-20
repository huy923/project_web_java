package dao;

import util.DatabaseConnection;
import java.sql.*;
import java.util.*;

public class PermissionDao {

    // Get all permissions
    public List<Map<String, Object>> getAllPermissions() throws SQLException {
        String sql = "SELECT * FROM permissions WHERE is_active = TRUE ORDER BY module, action";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> permissions = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> perm = new HashMap<>();
                perm.put("permission_id", rs.getInt("permission_id"));
                perm.put("permission_name", rs.getString("permission_name"));
                perm.put("description", rs.getString("description"));
                perm.put("module", rs.getString("module"));
                perm.put("action", rs.getString("action"));
                permissions.add(perm);
            }
            return permissions;
        }
    }

    // Get permissions by module
    public List<Map<String, Object>> getPermissionsByModule(String module) throws SQLException {
        String sql = "SELECT * FROM permissions WHERE module = ? AND is_active = TRUE ORDER BY action";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, module);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> permissions = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> perm = new HashMap<>();
                    perm.put("permission_id", rs.getInt("permission_id"));
                    perm.put("permission_name", rs.getString("permission_name"));
                    perm.put("description", rs.getString("description"));
                    permissions.add(perm);
                }
                return permissions;
            }
        }
    }

    // Check if user has permission
    public boolean hasPermission(int userId, String permissionName) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM role_permissions rp " +
                "JOIN user_roles ur ON rp.role_id = ur.role_id " +
                "JOIN permissions p ON rp.permission_id = p.permission_id " +
                "WHERE ur.user_id = ? AND p.permission_name = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, permissionName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        return false;
    }

    // Check if user has any of the permissions
    public boolean hasAnyPermission(int userId, String... permissionNames) throws SQLException {
        for (String permission : permissionNames) {
            if (hasPermission(userId, permission)) {
                return true;
            }
        }
        return false;
    }

    // Check if user has all permissions
    public boolean hasAllPermissions(int userId, String... permissionNames) throws SQLException {
        for (String permission : permissionNames) {
            if (!hasPermission(userId, permission)) {
                return false;
            }
        }
        return true;
    }

    // Get user permissions
    public Set<String> getUserPermissions(int userId) throws SQLException {
        String sql = "SELECT DISTINCT p.permission_name FROM permissions p " +
                "JOIN role_permissions rp ON p.permission_id = rp.permission_id " +
                "JOIN user_roles ur ON rp.role_id = ur.role_id " +
                "WHERE ur.user_id = ? AND p.is_active = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                Set<String> permissions = new HashSet<>();
                while (rs.next()) {
                    permissions.add(rs.getString("permission_name"));
                }
                return permissions;
            }
        }
    }

    // Get user roles
    public List<Map<String, Object>> getUserRoles(int userId) throws SQLException {
        String sql = "SELECT r.role_id, r.role_name, r.description FROM roles r " +
                "JOIN user_roles ur ON r.role_id = ur.role_id " +
                "WHERE ur.user_id = ? AND r.is_active = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> roles = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> role = new HashMap<>();
                    role.put("role_id", rs.getInt("role_id"));
                    role.put("role_name", rs.getString("role_name"));
                    role.put("description", rs.getString("description"));
                    roles.add(role);
                }
                return roles;
            }
        }
    }

    // Assign role to user
    public boolean assignRoleToUser(int userId, int roleId, int assignedBy) throws SQLException {
        String sql = "INSERT INTO user_roles (user_id, role_id, assigned_by) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roleId);
            ps.setInt(3, assignedBy);
            return ps.executeUpdate() == 1;
        }
    }

    // Remove role from user
    public boolean removeRoleFromUser(int userId, int roleId) throws SQLException {
        String sql = "DELETE FROM user_roles WHERE user_id = ? AND role_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roleId);
            return ps.executeUpdate() > 0;
        }
    }

    // Get all roles
    public List<Map<String, Object>> getAllRoles() throws SQLException {
        String sql = "SELECT * FROM roles WHERE is_active = TRUE ORDER BY role_name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> roles = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> role = new HashMap<>();
                role.put("role_id", rs.getInt("role_id"));
                role.put("role_name", rs.getString("role_name"));
                role.put("description", rs.getString("description"));
                roles.add(role);
            }
            return roles;
        }
    }

    // Get role permissions
    public List<Map<String, Object>> getRolePermissions(int roleId) throws SQLException {
        String sql = "SELECT p.* FROM permissions p " +
                "JOIN role_permissions rp ON p.permission_id = rp.permission_id " +
                "WHERE rp.role_id = ? AND p.is_active = TRUE ORDER BY p.module, p.action";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> permissions = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> perm = new HashMap<>();
                    perm.put("permission_id", rs.getInt("permission_id"));
                    perm.put("permission_name", rs.getString("permission_name"));
                    perm.put("module", rs.getString("module"));
                    perm.put("action", rs.getString("action"));
                    permissions.add(perm);
                }
                return permissions;
            }
        }
    }

    // Assign permission to role
    public boolean assignPermissionToRole(int roleId, int permissionId) throws SQLException {
        String sql = "INSERT INTO role_permissions (role_id, permission_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            return ps.executeUpdate() == 1;
        }
    }

    // Remove permission from role
    public boolean removePermissionFromRole(int roleId, int permissionId) throws SQLException {
        String sql = "DELETE FROM role_permissions WHERE role_id = ? AND permission_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean isUserInRole(int userId, String roleName) throws SQLException {
        String sql = "SELECT COUNT(*) AS count FROM user_roles ur JOIN roles r ON ur.role_id = r.role_id WHERE ur.user_id = ? AND LOWER(r.role_name) = LOWER(?) AND r.is_active = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, roleName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        return false;
    }
}
