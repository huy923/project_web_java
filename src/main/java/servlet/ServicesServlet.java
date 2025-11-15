package servlet;

import dao.ServiceDao;
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

@WebServlet("/services")
public class ServicesServlet extends HttpServlet {
    private ServiceDao serviceDao = new ServiceDao();

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
                // Display all services
                List<Map<String, Object>> services = serviceDao.getAllServices();
                request.setAttribute("services", services);
                request.getRequestDispatcher("/sections/services.jsp").forward(request, response);
            } else if ("view".equals(action)) {
                // View single service
                int serviceId = Integer.parseInt(request.getParameter("id"));
                Map<String, Object> service = serviceDao.getServiceById(serviceId);
                request.setAttribute("service", service);
                request.getRequestDispatcher("/sections/services.jsp").forward(request, response);
            } else if ("byCategory".equals(action)) {
                // Filter by category
                String category = request.getParameter("category");
                List<Map<String, Object>> services = serviceDao.getServicesByCategory(category);
                request.setAttribute("services", services);
                request.setAttribute("filterCategory", category);
                request.getRequestDispatcher("/sections/services.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading services: " + e.getMessage());
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
                // Add new service
                String serviceName = request.getParameter("serviceName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String category = request.getParameter("category");

                boolean success = serviceDao.addService(serviceName, description, price, category);

                if (success) {
                    request.setAttribute("successMessage", "Service added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add service");
                }

                doGet(request, response);
            } else if ("update".equals(action)) {
                // Update service
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                String serviceName = request.getParameter("serviceName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String category = request.getParameter("category");

                // Since ServiceDao doesn't have update method, delete and re-add
                serviceDao.deleteService(serviceId);
                boolean success = serviceDao.addService(serviceName, description, price, category);

                if (success) {
                    request.setAttribute("successMessage", "Service updated successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to update service");
                }

                doGet(request, response);
            } else if ("delete".equals(action)) {
                // Delete service
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));

                boolean success = serviceDao.deleteService(serviceId);

                if (success) {
                    request.setAttribute("successMessage", "Service deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete service");
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
