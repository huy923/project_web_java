package api;

import dao.PermissionDao;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PermissionApi", urlPatterns = {"/api/permissions", "/api/permission/*"})
public class PermissionApi extends HttpServlet {
    private Gson gson = new Gson();
    private PermissionDao permissionDao = new PermissionDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            String pathInfo = req.getPathInfo();
            String module = req.getParameter("module");
            String userId = req.getParameter("user_id");

            if (pathInfo == null || pathInfo.equals("/")) {
                if (module != null && !module.isEmpty()) {
                    getPermissionsByModule(req, resp, module);
                } else if (userId != null && !userId.isEmpty()) {
                    getUserPermissions(req, resp, Integer.parseInt(userId));
                } else {
                    getAllPermissions(req, resp);
                }
            }
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            String action = json.has("action") ? json.get("action").getAsString() : "";

            if ("assign_role".equals(action)) {
                int userId = json.get("user_id").getAsInt();
                int roleId = json.get("role_id").getAsInt();
                boolean success = permissionDao.assignRoleToUser(userId, roleId, 1);
                if (success) {
                    sendSuccessResponse(resp, "Role assigned successfully");
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to assign role");
                }
            } else if ("remove_role".equals(action)) {
                int userId = json.get("user_id").getAsInt();
                int roleId = json.get("role_id").getAsInt();
                boolean success = permissionDao.removeRoleFromUser(userId, roleId);
                if (success) {
                    sendSuccessResponse(resp, "Role removed successfully");
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to remove role");
                }
            } else if ("assign_permission".equals(action)) {
                int roleId = json.get("role_id").getAsInt();
                int permissionId = json.get("permission_id").getAsInt();
                boolean success = permissionDao.assignPermissionToRole(roleId, permissionId);
                if (success) {
                    sendSuccessResponse(resp, "Permission assigned successfully");
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to assign permission");
                }
            } else if ("remove_permission".equals(action)) {
                int roleId = json.get("role_id").getAsInt();
                int permissionId = json.get("permission_id").getAsInt();
                boolean success = permissionDao.removePermissionFromRole(roleId, permissionId);
                if (success) {
                    sendSuccessResponse(resp, "Permission removed successfully");
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to remove permission");
                }
            }
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
        }
    }

    private void getAllPermissions(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        List<Map<String, Object>> permissions = permissionDao.getAllPermissions();
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.add("data", gson.toJsonTree(permissions));
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getPermissionsByModule(HttpServletRequest req, HttpServletResponse resp, String module) throws SQLException, IOException {
        List<Map<String, Object>> permissions = permissionDao.getPermissionsByModule(module);
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.add("data", gson.toJsonTree(permissions));
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getUserPermissions(HttpServletRequest req, HttpServletResponse resp, int userId) throws SQLException, IOException {
        List<Map<String, Object>> roles = permissionDao.getUserRoles(userId);
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.add("data", gson.toJsonTree(roles));
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void sendSuccessResponse(HttpServletResponse resp, String message) throws IOException {
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("message", message);
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void sendErrorResponse(HttpServletResponse resp, int status, String message) throws IOException {
        resp.setStatus(status);
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", false);
        response.addProperty("message", message);
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void setResponseHeaders(HttpServletResponse resp) {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    }
}
