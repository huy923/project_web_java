package api;

import dao.ReportDao;
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
import java.util.Map;

@WebServlet(name = "ReportApi", urlPatterns = {"/api/reports", "/api/report/*"})
public class ReportApi extends HttpServlet {
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
            String reportType = req.getParameter("type");
            String startDate = req.getParameter("start_date");
            String endDate = req.getParameter("end_date");

            if (reportType == null || reportType.isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Report type is required");
                return;
            }

            ReportDao dao = new ReportDao();
            Map<String, Object> report = null;

            switch (reportType.toLowerCase()) {
                case "occupancy":
                    if (startDate == null || endDate == null) {
                        sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Start date and end date are required");
                        return;
                    }
                    report = dao.generateOccupancyReport(startDate, endDate);
                    break;
                case "revenue":
                    if (startDate == null || endDate == null) {
                        sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Start date and end date are required");
                        return;
                    }
                    report = dao.generateRevenueReport(startDate, endDate);
                    break;
                case "guest":
                    if (startDate == null || endDate == null) {
                        sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Start date and end date are required");
                        return;
                    }
                    report = dao.generateGuestAnalysis(startDate, endDate);
                    break;
                case "maintenance":
                    if (startDate == null || endDate == null) {
                        sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Start date and end date are required");
                        return;
                    }
                    report = dao.generateMaintenanceReport(startDate, endDate);
                    break;
                case "inventory":
                    report = dao.generateInventoryReport();
                    break;
                default:
                    sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid report type");
                    return;
            }

            if (report != null) {
                sendReportResponse(resp, report);
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate report");
            }
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
        }
    }

    private void sendReportResponse(HttpServletResponse resp, Map<String, Object> report) throws IOException {
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(report));

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
