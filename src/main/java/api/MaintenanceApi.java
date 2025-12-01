package api;

import dao.MaintenanceDao;
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

@WebServlet(name = "MaintenanceApi", urlPatterns = {"/api/maintenance", "/api/maintenance/*"})
public class MaintenanceApi extends HttpServlet {
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            String pathInfo = req.getPathInfo();
            String status = req.getParameter("status");
            String roomId = req.getParameter("room_id");
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/maintenance - Get all maintenance records
                if (status != null && !status.isEmpty()) {
                    getMaintenanceByStatus(req, resp, status);
                } else if (roomId != null && !roomId.isEmpty()) {
                    getMaintenanceByRoom(req, resp, Integer.parseInt(roomId));
                } else {
                    getAllMaintenance(req, resp);
                }
            } else {
                // GET /api/maintenance/{id} - Get maintenance by ID
                String[] parts = pathInfo.split("/");
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    int maintenanceId = Integer.parseInt(parts[1]);
                    getMaintenanceById(req, resp, maintenanceId);
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid maintenance ID");
                }
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            // Parse JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            
            int roomId = json.has("room_id") ? json.get("room_id").getAsInt() : 0;
            String issueDescription = json.has("issue_description") ? json.get("issue_description").getAsString() : "";
            int reportedBy = json.has("reported_by") ? json.get("reported_by").getAsInt() : 0;
            String priority = json.has("priority") ? json.get("priority").getAsString() : "";

            if (roomId == 0 || issueDescription.isEmpty() || priority.isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            MaintenanceDao dao = new MaintenanceDao();
            boolean success = dao.addMaintenanceRecord(roomId, issueDescription, reportedBy, priority);

            if (success) {
                sendSuccessResponse(resp, "Maintenance record created successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create maintenance record");
            }
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            String pathInfo = req.getPathInfo();
            String[] parts = pathInfo.split("/");
            
            if (parts.length <= 1 || parts[1].isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Maintenance ID required");
                return;
            }

            int maintenanceId = Integer.parseInt(parts[1]);

            // Parse JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            
            String status = json.has("status") ? json.get("status").getAsString() : "";
            Integer assignedTo = json.has("assigned_to") ? json.get("assigned_to").getAsInt() : null;
            Double actualCost = json.has("actual_cost") ? json.get("actual_cost").getAsDouble() : null;

            MaintenanceDao dao = new MaintenanceDao();
            boolean success = false;

            if (status != null && !status.isEmpty()) {
                success = dao.updateMaintenanceStatus(maintenanceId, status);
            }
            
            if (assignedTo != null) {
                success = dao.assignMaintenance(maintenanceId, assignedTo);
            }
            
            if (actualCost != null && actualCost > 0) {
                success = dao.completeMaintenance(maintenanceId, actualCost);
            }

            if (success) {
                sendSuccessResponse(resp, "Maintenance record updated successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update maintenance record");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            String pathInfo = req.getPathInfo();
            String[] parts = pathInfo.split("/");
            
            if (parts.length <= 1 || parts[1].isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Maintenance ID required");
                return;
            }

            int maintenanceId = Integer.parseInt(parts[1]);

            MaintenanceDao dao = new MaintenanceDao();
            boolean success = dao.deleteMaintenanceRecord(maintenanceId);

            if (success) {
                sendSuccessResponse(resp, "Maintenance record deleted successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete maintenance record");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid maintenance ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void getAllMaintenance(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        MaintenanceDao dao = new MaintenanceDao();
        List<Map<String, Object>> records = dao.getAllMaintenanceRecords();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(records));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getMaintenanceByStatus(HttpServletRequest req, HttpServletResponse resp, String status) throws SQLException, IOException {
        MaintenanceDao dao = new MaintenanceDao();
        List<Map<String, Object>> records = dao.getMaintenanceByStatus(status);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(records));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getMaintenanceByRoom(HttpServletRequest req, HttpServletResponse resp, int roomId) throws SQLException, IOException {
        MaintenanceDao dao = new MaintenanceDao();
        List<Map<String, Object>> records = dao.getMaintenanceByRoom(roomId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(records));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getMaintenanceById(HttpServletRequest req, HttpServletResponse resp, int maintenanceId) throws SQLException, IOException {
        MaintenanceDao dao = new MaintenanceDao();
        Map<String, Object> record = dao.getMaintenanceById(maintenanceId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", record != null);
        response.addProperty("timestamp", System.currentTimeMillis());
        
        if (record != null) {
            response.add("data", gson.toJsonTree(record));
        } else {
            response.addProperty("message", "Maintenance record not found");
        }

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void sendSuccessResponse(HttpServletResponse resp, String message) throws IOException {
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("message", message);
        response.addProperty("timestamp", System.currentTimeMillis());

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
        response.addProperty("timestamp", System.currentTimeMillis());

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void setResponseHeaders(HttpServletResponse resp) {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Expires", "0");
    }
}
