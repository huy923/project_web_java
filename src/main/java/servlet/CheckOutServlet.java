package servlet;

import dao.BookingDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckOutServlet", urlPatterns = { "/check-out" })
public class CheckOutServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }

        try {
            BookingDao dao = new BookingDao();
            List<Map<String, Object>> bookings = dao.getAllBookings();
            req.setAttribute("bookings", bookings);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Error loading bookings: " + e.getMessage());
        }

        req.getRequestDispatcher("/sections/check-out.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }

        try {
            String bookingIdStr = req.getParameter("bookingId");
            String checkOutTimeStr = req.getParameter("checkOutTime");
            String paymentMethod = req.getParameter("paymentMethod");

            // Validate required parameters
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty() ||
                    checkOutTimeStr == null || checkOutTimeStr.trim().isEmpty() ||
                    paymentMethod == null || paymentMethod.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Booking ID, Check-out Time, and Payment Method are required");
                doGet(req, resp);
                return;
            }

            int bookingId = Integer.parseInt(bookingIdStr);
            BookingDao dao = new BookingDao();

            // Get room ID for this booking
            int roomId = dao.getRoomIdByBooking(bookingId);

            // Update booking status to checked_out
            boolean success = dao.updateBookingStatus(bookingId, "checked_out");
            
            if (success && roomId != -1) {
                // Update room status to available
                dao.updateRoomStatus(roomId, "available");
                req.setAttribute("successMessage", "Check-out completed successfully!");
            } else {
                req.setAttribute("errorMessage", "Failed to complete check-out");
            }

            doGet(req, resp);
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid booking ID format");
            doGet(req, resp);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
