package util;

import dao.PermissionDao;
import model.User;
import javax.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.Set;

public class PermissionUtil {

    private static PermissionDao permissionDao = new PermissionDao();

    /**
     * Check if user has specific permission
     */
    public static boolean hasPermission(HttpSession session, String permissionName) {
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;

        try {
            return permissionDao.hasPermission(user.getUserId(), permissionName);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if user has any of the permissions
     */
    public static boolean hasAnyPermission(HttpSession session, String... permissions) {
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;

        try {
            return permissionDao.hasAnyPermission(user.getUserId(), permissions);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if user has all permissions
     */
    public static boolean hasAllPermissions(HttpSession session, String... permissions) {
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;

        try {
            return permissionDao.hasAllPermissions(user.getUserId(), permissions);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all user permissions
     */
    public static Set<String> getUserPermissions(HttpSession session) {
        if (session == null) return null;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return null;

        try {
            return permissionDao.getUserPermissions(user.getUserId());
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Check if user can view module
     */
    public static boolean canViewModule(HttpSession session, String module) {
        return hasPermission(session, module + ".view");
    }

    /**
     * Check if user can create in module
     */
    public static boolean canCreate(HttpSession session, String module) {
        return hasPermission(session, module + ".create");
    }

    /**
     * Check if user can edit in module
     */
    public static boolean canEdit(HttpSession session, String module) {
        return hasPermission(session, module + ".edit");
    }

    /**
     * Check if user can delete in module
     */
    public static boolean canDelete(HttpSession session, String module) {
        return hasPermission(session, module + ".delete");
    }

    /**
     * Check if user is admin
     */
    public static boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;

        if ("admin".equalsIgnoreCase(user.getRole())) {
            return true;
        }

        return hasAnyPermission(session, "users.view", "settings.system", "settings.view");
    }

    /**
     * Check if user is manager
     */
    public static boolean isManager(HttpSession session) {
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;

        if ("manager".equalsIgnoreCase(user.getRole())) {
            return true;
        }

        return hasAnyPermission(session, "reports.view", "rooms.edit", "bookings.edit", "payments.edit");
    }
}
