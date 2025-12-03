package servlet;

import dao.PaymentDao;
import model.User;

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

@WebServlet(name = "PaymentsServlet", urlPatterns = {"/payments"})
public class PaymentsServlet extends HttpServlet {
    private PaymentDao paymentDao = new PaymentDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Get filter parameter
            String statusFilter = req.getParameter("status");
            
            List<Map<String, Object>> payments;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                payments = paymentDao.getPaymentsByStatus(statusFilter);
            } else {
                payments = paymentDao.getAllPayments();
            }
            
            req.setAttribute("payments", payments);
            req.setAttribute("statusFilter", statusFilter);
            
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi khi tải dữ liệu thanh toán: " + e.getMessage());
            e.printStackTrace();
        }

        req.getRequestDispatcher("/sections/payments.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        User currentUser = (User) session.getAttribute("user");

        try {
            if ("add_payment".equals(action)) {
                int bookingId = Integer.parseInt(req.getParameter("booking_id"));
                double amount = Double.parseDouble(req.getParameter("amount"));
                String paymentType = req.getParameter("payment_type");
                String transactionId = req.getParameter("transaction_id");
                String notes = req.getParameter("notes");

                boolean success = paymentDao.createPayment(bookingId, amount, paymentType, 
                                                         transactionId, currentUser.getUserId(), notes);
                
                if (success) {
                    req.setAttribute("successMessage", "Payment added successfully!");
                } else {
                    req.setAttribute("errorMessage", "Failed to add payment!");
                }
            } else if ("update_status".equals(action)) {
                int paymentId = Integer.parseInt(req.getParameter("payment_id"));
                String newStatus = req.getParameter("new_status");

                boolean success = paymentDao.updatePaymentStatus(paymentId, newStatus);
                
                if (success) {
                    req.setAttribute("successMessage", "Payment status updated successfully!");
                } else {
                    req.setAttribute("errorMessage", "Failed to update payment status!");
                }
            }
        } catch (SQLException | NumberFormatException e) {
            req.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            e.printStackTrace();
        }

        // Forward back to payments page instead of redirect
        doGet(req, resp);
    }
}
