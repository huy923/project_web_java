package api;

import dao.InventoryDao;
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

@WebServlet(name = "InventoryApi", urlPatterns = {"/api/inventory", "/api/inventory/*"})
public class InventoryApi extends HttpServlet {
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
            String lowStock = req.getParameter("low_stock");
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/inventory - Get all inventory items
                if (category != null && !category.isEmpty()) {
                    getInventoryByCategory(req, resp, category);
                } else if (lowStock != null && lowStock.equals("true")) {
                    getLowStockItems(req, resp);
                } else {
                    getAllInventory(req, resp);
                }
            } else {
                // GET /api/inventory/{id} - Get inventory item by ID
                String[] parts = pathInfo.split("/");
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    int itemId = Integer.parseInt(parts[1]);
                    getInventoryById(req, resp, itemId);
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid item ID");
                }
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid item ID format");
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
            
            String itemName = json.has("item_name") ? json.get("item_name").getAsString() : "";
            String category = json.has("category") ? json.get("category").getAsString() : "";
            int currentStock = json.has("current_stock") ? json.get("current_stock").getAsInt() : 0;
            int minimumStock = json.has("minimum_stock") ? json.get("minimum_stock").getAsInt() : 0;
            double unitPrice = json.has("unit_price") ? json.get("unit_price").getAsDouble() : 0;
            String supplier = json.has("supplier") ? json.get("supplier").getAsString() : "";

            if (itemName.isEmpty() || category.isEmpty() || unitPrice == 0) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            InventoryDao dao = new InventoryDao();
            boolean success = dao.addInventoryItem(itemName, category, currentStock, minimumStock, unitPrice, supplier);

            if (success) {
                sendSuccessResponse(resp, "Inventory item added successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add inventory item");
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
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Item ID required");
                return;
            }

            int itemId = Integer.parseInt(parts[1]);

            // Parse JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            
            Integer newStock = json.has("current_stock") ? json.get("current_stock").getAsInt() : null;
            Integer addQuantity = json.has("add_quantity") ? json.get("add_quantity").getAsInt() : null;
            Integer removeQuantity = json.has("remove_quantity") ? json.get("remove_quantity").getAsInt() : null;

            InventoryDao dao = new InventoryDao();
            boolean success = false;

            if (newStock != null) {
                success = dao.updateInventoryStock(itemId, newStock);
            } else if (addQuantity != null && addQuantity > 0) {
                success = dao.addStock(itemId, addQuantity);
            } else if (removeQuantity != null && removeQuantity > 0) {
                success = dao.removeStock(itemId, removeQuantity);
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "No valid stock update provided");
                return;
            }

            if (success) {
                sendSuccessResponse(resp, "Inventory item updated successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update inventory item");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid item ID format");
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
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Item ID required");
                return;
            }

            int itemId = Integer.parseInt(parts[1]);

            InventoryDao dao = new InventoryDao();
            boolean success = dao.deleteInventoryItem(itemId);

            if (success) {
                sendSuccessResponse(resp, "Inventory item deleted successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete inventory item");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid item ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void getAllInventory(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        InventoryDao dao = new InventoryDao();
        List<Map<String, Object>> items = dao.getAllInventory();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(items));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getInventoryByCategory(HttpServletRequest req, HttpServletResponse resp, String category) throws SQLException, IOException {
        InventoryDao dao = new InventoryDao();
        List<Map<String, Object>> items = dao.getInventoryByCategory(category);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(items));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getLowStockItems(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        InventoryDao dao = new InventoryDao();
        List<Map<String, Object>> items = dao.getLowStockItems();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(items));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getInventoryById(HttpServletRequest req, HttpServletResponse resp, int itemId) throws SQLException, IOException {
        InventoryDao dao = new InventoryDao();
        Map<String, Object> item = dao.getInventoryById(itemId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", item != null);
        response.addProperty("timestamp", System.currentTimeMillis());
        
        if (item != null) {
            response.add("data", gson.toJsonTree(item));
        } else {
            response.addProperty("message", "Inventory item not found");
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
