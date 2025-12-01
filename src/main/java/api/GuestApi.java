package api;

import dao.GuestDao;
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

@WebServlet(name = "GuestApi", urlPatterns = {"/api/guests", "/api/guest/*"})
public class GuestApi extends HttpServlet {
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
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/guests - Get all guests
                getAllGuests(req, resp);
            } else {
                // GET /api/guest/{id} - Get guest by ID
                String[] parts = pathInfo.split("/");
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    int guestId = Integer.parseInt(parts[1]);
                    getGuestById(req, resp, guestId);
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid guest ID");
                }
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid guest ID format");
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
            
            String firstName = json.has("first_name") ? json.get("first_name").getAsString() : "";
            String lastName = json.has("last_name") ? json.get("last_name").getAsString() : "";
            String email = json.has("email") ? json.get("email").getAsString() : "";
            String phone = json.has("phone") ? json.get("phone").getAsString() : "";
            String idNumber = json.has("id_number") ? json.get("id_number").getAsString() : "";
            String nationality = json.has("nationality") ? json.get("nationality").getAsString() : "";

            if (firstName.isEmpty() || lastName.isEmpty() || phone.isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            GuestDao dao = new GuestDao();
            boolean success = dao.addGuest(firstName, lastName, email, phone, idNumber, nationality);

            if (success) {
                sendSuccessResponse(resp, "Guest added successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add guest");
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
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Guest ID required");
                return;
            }

            int guestId = Integer.parseInt(parts[1]);

            // Parse JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            
            String firstName = json.has("first_name") ? json.get("first_name").getAsString() : "";
            String lastName = json.has("last_name") ? json.get("last_name").getAsString() : "";
            String email = json.has("email") ? json.get("email").getAsString() : "";
            String phone = json.has("phone") ? json.get("phone").getAsString() : "";
            String idNumber = json.has("id_number") ? json.get("id_number").getAsString() : "";
            String nationality = json.has("nationality") ? json.get("nationality").getAsString() : "";

            if (firstName.isEmpty() || lastName.isEmpty() || phone.isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            GuestDao dao = new GuestDao();
            boolean success = dao.updateGuest(guestId, firstName, lastName, email, phone, idNumber, nationality);

            if (success) {
                sendSuccessResponse(resp, "Guest updated successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update guest");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid guest ID format");
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
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Guest ID required");
                return;
            }

            int guestId = Integer.parseInt(parts[1]);

            GuestDao dao = new GuestDao();
            boolean success = dao.deleteGuest(guestId);

            if (success) {
                sendSuccessResponse(resp, "Guest deleted successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete guest");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid guest ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void getAllGuests(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        GuestDao dao = new GuestDao();
        List<Map<String, Object>> guests = dao.getAllGuests();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(guests));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getGuestById(HttpServletRequest req, HttpServletResponse resp, int guestId) throws SQLException, IOException {
        GuestDao dao = new GuestDao();
        Map<String, Object> guest = dao.getGuestById(guestId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", guest != null);
        response.addProperty("timestamp", System.currentTimeMillis());
        
        if (guest != null) {
            response.add("data", gson.toJsonTree(guest));
        } else {
            response.addProperty("message", "Guest not found");
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
