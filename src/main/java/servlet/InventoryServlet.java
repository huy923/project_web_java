package servlet;

import dao.InventoryDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {
    private InventoryDao inventoryDao = new InventoryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String action = request.getParameter("action");

            if (action == null) {
                // Display all inventory items
                List<Map<String, Object>> items = inventoryDao.getAllInventory();
                request.setAttribute("items", items);
                int lowStockCount = inventoryDao.countLowStockItems();
                request.setAttribute("lowStockCount", lowStockCount);
                request.getRequestDispatcher("/sections/inventory.jsp").forward(request, response);
            } else if ("view".equals(action)) {
                // View single inventory item
                int itemId = Integer.parseInt(request.getParameter("id"));
                Map<String, Object> item = inventoryDao.getInventoryById(itemId);
                request.setAttribute("item", item);
                request.getRequestDispatcher("/sections/inventory.jsp").forward(request, response);
            } else if ("lowStock".equals(action)) {
                // Show low stock items only
                List<Map<String, Object>> items = inventoryDao.getLowStockItems();
                request.setAttribute("items", items);
                request.setAttribute("filterLowStock", true);
                request.getRequestDispatcher("/sections/inventory.jsp").forward(request, response);
            } else if ("byCategory".equals(action)) {
                // Filter by category
                String category = request.getParameter("category");
                List<Map<String, Object>> items = inventoryDao.getInventoryByCategory(category);
                request.setAttribute("items", items);
                request.setAttribute("filterCategory", category);
                request.getRequestDispatcher("/sections/inventory.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading inventory: " + e.getMessage());
            try {
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("add".equals(action)) {
                // Add new inventory item
                String itemName = request.getParameter("itemName");
                String category = request.getParameter("category");
                int currentStock = Integer.parseInt(request.getParameter("currentStock"));
                int minimumStock = Integer.parseInt(request.getParameter("minimumStock"));
                double unitPrice = Double.parseDouble(request.getParameter("unitPrice"));
                String supplier = request.getParameter("supplier");

                boolean success = inventoryDao.addInventoryItem(itemName, category, currentStock, minimumStock,
                        unitPrice, supplier);

                if (success) {
                    request.setAttribute("successMessage", "Inventory item added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add inventory item");
                }

                doGet(request, response);
            } else if ("updateStock".equals(action)) {
                // Update stock quantity
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int newStock = Integer.parseInt(request.getParameter("newStock"));

                boolean success = inventoryDao.updateInventoryStock(itemId, newStock);

                if (success) {
                    request.setAttribute("successMessage", "Stock updated successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to update stock");
                }

                doGet(request, response);
            } else if ("addStock".equals(action)) {
                // Add to existing stock
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                boolean success = inventoryDao.addStock(itemId, quantity);

                if (success) {
                    request.setAttribute("successMessage", "Stock added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add stock");
                }

                doGet(request, response);
            } else if ("removeStock".equals(action)) {
                // Remove from stock
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                boolean success = inventoryDao.removeStock(itemId, quantity);

                if (success) {
                    request.setAttribute("successMessage", "Stock removed successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to remove stock");
                }

                doGet(request, response);
            } else if ("delete".equals(action)) {
                // Delete inventory item
                int itemId = Integer.parseInt(request.getParameter("itemId"));

                boolean success = inventoryDao.deleteInventoryItem(itemId);

                if (success) {
                    request.setAttribute("successMessage", "Inventory item deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete inventory item");
                }

                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid input format: " + e.getMessage());
            try {
                doGet(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            try {
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        }
    }
}
