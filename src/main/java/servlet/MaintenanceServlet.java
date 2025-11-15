package servlet;

import dao.MaintenanceDao;
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

@WebServlet("/maintenance")
public class MaintenanceServlet extends HttpServlet {
    private MaintenanceDao maintenanceDao = new MaintenanceDao();

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
                // Display all maintenance records
                List<Map<String, Object>> records = maintenanceDao.getAllMaintenanceRecords();
                request.setAttribute("records", records);
                request.getRequestDispatcher("/sections/maintenance.jsp").forward(request, response);
            } else if ("view".equals(action)) {
                // View single maintenance record
                int maintenanceId = Integer.parseInt(request.getParameter("id"));
                Map<String, Object> record = maintenanceDao.getMaintenanceById(maintenanceId);
                request.setAttribute("record", record);
                request.getRequestDispatcher("/sections/maintenance.jsp").forward(request, response);
            } else if ("byStatus".equals(action)) {
                // Filter by status
                String status = request.getParameter("status");
                List<Map<String, Object>> records = maintenanceDao.getMaintenanceByStatus(status);
                request.setAttribute("records", records);
                request.setAttribute("filterStatus", status);
                request.getRequestDispatcher("/sections/maintenance.jsp").forward(request, response);
            } else if ("byRoom".equals(action)) {
                // Filter by room
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                List<Map<String, Object>> records = maintenanceDao.getMaintenanceByRoom(roomId);
                request.setAttribute("records", records);
                request.getRequestDispatcher("/sections/maintenance.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading maintenance records: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
                // Add new maintenance record
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                String issueDescription = request.getParameter("issueDescription");
                String priority = request.getParameter("priority");
                int reportedBy = (Integer) session.getAttribute("userId");

                boolean success = maintenanceDao.addMaintenanceRecord(roomId, issueDescription, reportedBy, priority);

                if (success) {
                    request.setAttribute("successMessage", "Maintenance record added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add maintenance record");
                }

                doGet(request, response);
            } else if ("updateStatus".equals(action)) {
                // Update maintenance status
                int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));
                String status = request.getParameter("status");

                boolean success = maintenanceDao.updateMaintenanceStatus(maintenanceId, status);

                if (success) {
                    request.setAttribute("successMessage", "Status updated successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to update status");
                }

                doGet(request, response);
            } else if ("assign".equals(action)) {
                // Assign maintenance to staff
                int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));
                int assignedToId = Integer.parseInt(request.getParameter("assignedTo"));

                boolean success = maintenanceDao.assignMaintenance(maintenanceId, assignedToId);

                if (success) {
                    request.setAttribute("successMessage", "Maintenance assigned successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to assign maintenance");
                }

                doGet(request, response);
            } else if ("complete".equals(action)) {
                // Complete maintenance
                int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));
                double actualCost = Double.parseDouble(request.getParameter("actualCost"));

                boolean success = maintenanceDao.completeMaintenance(maintenanceId, actualCost);

                if (success) {
                    request.setAttribute("successMessage", "Maintenance marked as complete");
                } else {
                    request.setAttribute("errorMessage", "Failed to complete maintenance");
                }

                doGet(request, response);
            } else if ("delete".equals(action)) {
                // Delete maintenance record
                int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));

                boolean success = maintenanceDao.deleteMaintenanceRecord(maintenanceId);

                if (success) {
                    request.setAttribute("successMessage", "Maintenance record deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete maintenance record");
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
