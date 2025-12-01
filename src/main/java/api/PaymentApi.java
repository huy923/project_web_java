package api;

import dao.PaymentDao;
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

@WebServlet(name = "PaymentApi", urlPatterns = {"/api/payments", "/api/payment/*"})
public class PaymentApi extends HttpServlet {
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
                // GET /api/payments - Get all payments
                getAllPayments(req, resp);
            } else {
                // GET /api/payment/{id} - Get payment by ID
                String[] parts = pathInfo.split("/");
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    int paymentId = Integer.parseInt(parts[1]);
                    getPaymentById(req, resp, paymentId);
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid payment ID");
                }
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid payment ID format");
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
            double amount = json.has("amount") ? json.get("amount").getAsDouble() : 0;
            String paymentType = json.has("payment_type") ? json.get("payment_type").getAsString() : "";
            String transactionId = json.has("transaction_id") ? json.get("transaction_id").getAsString() : "";
            int processedBy = json.has("processed_by") ? json.get("processed_by").getAsInt() : 0;
            String notes = json.has("notes") ? json.get("notes").getAsString() : "";

            if (bookingId == 0 || amount == 0 || paymentType.isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            PaymentDao dao = new PaymentDao();
            boolean success = dao.createPayment(bookingId, amount, paymentType, transactionId, processedBy, notes);

            if (success) {
                sendSuccessResponse(resp, "Payment created successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create payment");
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
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Payment ID required");
                return;
            }

            int paymentId = Integer.parseInt(parts[1]);

            // Parse JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            
            String status = json.has("payment_status") ? json.get("payment_status").getAsString() : "";

            if (status.isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Payment status is required");
                return;
            }

            PaymentDao dao = new PaymentDao();
            boolean success = dao.updatePaymentStatus(paymentId, status);

            if (success) {
                sendSuccessResponse(resp, "Payment updated successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update payment");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid payment ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
        }
    }

    private void getAllPayments(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        PaymentDao dao = new PaymentDao();
        List<Map<String, Object>> payments = dao.getAllPayments();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(payments));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getPaymentById(HttpServletRequest req, HttpServletResponse resp, int paymentId) throws SQLException, IOException {
        PaymentDao dao = new PaymentDao();
        Map<String, Object> payment = dao.getPaymentById(paymentId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", payment != null);
        response.addProperty("timestamp", System.currentTimeMillis());
        
        if (payment != null) {
            response.add("data", gson.toJsonTree(payment));
        } else {
            response.addProperty("message", "Payment not found");
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
