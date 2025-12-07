package api;

import dao.GuestServiceDao;
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

@WebServlet(name = "GuestServiceApi", urlPatterns = {"/api/guest-services", "/api/guest-service/*"})
public class GuestServiceApi extends HttpServlet {
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
            String bookingId = req.getParameter("booking_id");
            String guestId = req.getParameter("guest_id");
            String status = req.getParameter("status");
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/guest-services - Get all guest services
                if (bookingId != null && !bookingId.isEmpty()) {
                    getServicesByBooking(req, resp, Integer.parseInt(bookingId));
                } else if (guestId != null && !guestId.isEmpty()) {
                    getServicesByGuest(req, resp, Integer.parseInt(guestId));
                } else if (status != null && !status.isEmpty()) {
                    getServicesByStatus(req, resp, status);
                } else {
                    getAllGuestServices(req, resp);
                }
            } else {
                // GET /api/guest-service/{id} - Get guest service by ID
                String[] parts = pathInfo.split("/");
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    int serviceId = Integer.parseInt(parts[1]);
                    getGuestServiceById(req, resp, serviceId);
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid service ID");
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
            
            int bookingId = json.has("booking_id") ? json.get("booking_id").getAsInt() : 0;
            int serviceId = json.has("service_id") ? json.get("service_id").getAsInt() : 0;
            int quantity = json.has("quantity") ? json.get("quantity").getAsInt() : 1;
            double unitPrice = json.has("unit_price") ? json.get("unit_price").getAsDouble() : 0.0;

            if (bookingId == 0 || serviceId == 0) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            GuestServiceDao dao = new GuestServiceDao();
            boolean success = dao.addGuestService(bookingId, serviceId, quantity, unitPrice);

            if (success) {
                sendSuccessResponse(resp, "Guest service added successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add guest service");
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
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Service ID required");
                return;
            }

            int serviceId = Integer.parseInt(parts[1]);

            // Parse JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            
            String status = json.has("status") ? json.get("status").getAsString() : "";
            Integer quantity = json.has("quantity") ? json.get("quantity").getAsInt() : null;

            GuestServiceDao dao = new GuestServiceDao();
            boolean success = false;

            if (!status.isEmpty()) {
                success = dao.updateServiceStatus(serviceId, status);
            } else if (quantity != null && quantity > 0) {
                success = dao.updateServiceQuantity(serviceId, quantity);
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid update parameters");
                return;
            }

            if (success) {
                sendSuccessResponse(resp, "Guest service updated successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update guest service");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid service ID format");
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
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Service ID required");
                return;
            }

            int serviceId = Integer.parseInt(parts[1]);

            GuestServiceDao dao = new GuestServiceDao();
            boolean success = dao.deleteGuestService(serviceId);

            if (success) {
                sendSuccessResponse(resp, "Guest service deleted successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete guest service");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid service ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void getAllGuestServices(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        GuestServiceDao dao = new GuestServiceDao();
        List<Map<String, Object>> services = dao.getAllGuestServices();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(services));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getServicesByBooking(HttpServletRequest req, HttpServletResponse resp, int bookingId) throws SQLException, IOException {
        GuestServiceDao dao = new GuestServiceDao();
        List<Map<String, Object>> services = dao.getServicesByBooking(bookingId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(services));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getServicesByGuest(HttpServletRequest req, HttpServletResponse resp, int guestId) throws SQLException, IOException {
        GuestServiceDao dao = new GuestServiceDao();
        List<Map<String, Object>> services = dao.getServicesByGuest(guestId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(services));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getServicesByStatus(HttpServletRequest req, HttpServletResponse resp, String status) throws SQLException, IOException {
        GuestServiceDao dao = new GuestServiceDao();
        List<Map<String, Object>> services = dao.getServicesByStatus(status);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(services));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getGuestServiceById(HttpServletRequest req, HttpServletResponse resp, int serviceId) throws SQLException, IOException {
        GuestServiceDao dao = new GuestServiceDao();
        Map<String, Object> service = dao.getGuestServiceById(serviceId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", service != null);
        response.addProperty("timestamp", System.currentTimeMillis());
        
        if (service != null) {
            response.add("data", gson.toJsonTree(service));
        } else {
            response.addProperty("message", "Guest service not found");
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
