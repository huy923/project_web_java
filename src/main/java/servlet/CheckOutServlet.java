package servlet;

import dao.BookingDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "CheckOutServlet", urlPatterns = { "/check-out" })
public class CheckOutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/sections/check-out.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String bookingIdStr = req.getParameter("bookingId");

            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Booking ID is required");
                doGet(req, resp);
                return;
            }

            int bookingId = Integer.parseInt(bookingIdStr);
            BookingDao dao = new BookingDao();

            // Get room ID for this booking
            int roomId = dao.getRoomIdByBooking(bookingId);

            // Checkout booking
            boolean success = dao.checkoutBooking(bookingId);

            if (success && roomId != -1) {
                // Update room status to available
                dao.updateRoomStatus(roomId, "available");
                resp.sendRedirect(req.getContextPath() + "/dashboard?success=checkout");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard?error=checkout");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid booking ID format");
            doGet(req, resp);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
