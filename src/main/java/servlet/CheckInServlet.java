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

@WebServlet(name = "CheckInServlet", urlPatterns = { "/check-in" })
public class CheckInServlet extends BaseServlet {
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

        req.getRequestDispatcher("/sections/check-in.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }

        try {
            String bookingIdStr = req.getParameter("bookingId");
            String checkInTimeStr = req.getParameter("checkInTime");

            // Validate required parameters
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty() ||
                    checkInTimeStr == null || checkInTimeStr.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Booking ID and Check-in Time are required");
                doGet(req, resp);
                return;
            }

            int bookingId = Integer.parseInt(bookingIdStr);
            BookingDao dao = new BookingDao();

            // Update booking status to checked_in
            boolean success = dao.updateBookingStatus(bookingId, "checked_in");

            if (success) {
                // Get booking details to update room status
                Map<String, Object> booking = dao.getBookingById(bookingId);
                if (booking != null) {
                    int roomId = (int) booking.get("room_id");
                    dao.updateRoomStatus(roomId, "occupied");
                }

                req.setAttribute("successMessage", "Check-in completed successfully!");
            } else {
                req.setAttribute("errorMessage", "Failed to complete check-in");
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
