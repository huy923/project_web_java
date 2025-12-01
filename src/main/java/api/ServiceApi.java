package api;

import dao.ServiceDao;
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

@WebServlet(name = "ServiceApi", urlPatterns = {"/api/services", "/api/service/*"})
public class ServiceApi extends HttpServlet {
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
            String category = req.getParameter("category");
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/services - Get all services or by category
                if (category != null && !category.isEmpty()) {
                    getServicesByCategory(req, resp, category);
                } else {
                    getAllServices(req, resp);
                }
            } else {
                // GET /api/service/{id} - Get service by ID
                String[] parts = pathInfo.split("/");
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    int serviceId = Integer.parseInt(parts[1]);
                    getServiceById(req, resp, serviceId);
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid service ID");
                }
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid service ID format");
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
            
            String serviceName = json.has("service_name") ? json.get("service_name").getAsString() : "";
            String description = json.has("description") ? json.get("description").getAsString() : "";
            double price = json.has("price") ? json.get("price").getAsDouble() : 0;
            String category = json.has("category") ? json.get("category").getAsString() : "";

            if (serviceName.isEmpty() || price == 0 || category.isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            ServiceDao dao = new ServiceDao();
            boolean success = dao.addService(serviceName, description, price, category);

            if (success) {
                sendSuccessResponse(resp, "Service added successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add service");
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
            
            String serviceName = json.has("service_name") ? json.get("service_name").getAsString() : "";
            String description = json.has("description") ? json.get("description").getAsString() : "";
            double price = json.has("price") ? json.get("price").getAsDouble() : 0;
            String category = json.has("category") ? json.get("category").getAsString() : "";

            if (serviceName.isEmpty() || price == 0 || category.isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            ServiceDao dao = new ServiceDao();
            boolean success = dao.updateService(serviceId, serviceName, description, price, category);

            if (success) {
                sendSuccessResponse(resp, "Service updated successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update service");
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

            ServiceDao dao = new ServiceDao();
            boolean success = dao.deleteService(serviceId);

            if (success) {
                sendSuccessResponse(resp, "Service deleted successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete service");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid service ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void getAllServices(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        ServiceDao dao = new ServiceDao();
        List<Map<String, Object>> services = dao.getAllServices();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(services));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getServicesByCategory(HttpServletRequest req, HttpServletResponse resp, String category) throws SQLException, IOException {
        ServiceDao dao = new ServiceDao();
        List<Map<String, Object>> services = dao.getServicesByCategory(category);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(services));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getServiceById(HttpServletRequest req, HttpServletResponse resp, int serviceId) throws SQLException, IOException {
        ServiceDao dao = new ServiceDao();
        Map<String, Object> service = dao.getServiceById(serviceId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", service != null);
        response.addProperty("timestamp", System.currentTimeMillis());
        
        if (service != null) {
            response.add("data", gson.toJsonTree(service));
        } else {
            response.addProperty("message", "Service not found");
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
