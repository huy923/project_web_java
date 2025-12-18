package servlet;

import dao.BookingDao;
import dao.RoomDao;
import dao.GuestDao;
import model.User;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "BookingsServlet", urlPatterns = { "/bookings" })
public class BookingsServlet extends BaseServlet {

    private BookingDao bookingDao = new BookingDao();
    private RoomDao roomDao = new RoomDao();
    private GuestDao guestDao = new GuestDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }

        try {
            // Get all bookings with guest and room information
            List<Map<String, Object>> bookings = bookingDao.getAllBookings();
            req.setAttribute("bookings", bookings);

            // Get available rooms for new booking
            List<Map<String, Object>> availableRooms = bookingDao.getAvailableRooms();
            req.setAttribute("availableRooms", availableRooms);

            // Get room types for booking form
            List<Map<String, Object>> roomTypes = roomDao.getRoomTypes();
            req.setAttribute("roomTypes", roomTypes);

            // Get all guests for reference
            List<Map<String, Object>> guests = guestDao.getAllGuests();
            req.setAttribute("guests", guests);

        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            e.printStackTrace();
        }

        req.getRequestDispatcher("/sections/bookings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }

        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        try {
            switch (action) {
                case "create":
                    if (createBooking(req, user)) {
                        req.setAttribute("successMessage", "Booking created successfully!");
                    } else {
                        req.setAttribute("errorMessage", "Failed to create booking");
                    }
                    break;
                case "checkin":
                    if (checkInBooking(req)) {
                        req.setAttribute("successMessage", "Guest checked in successfully!");
                    } else {
                        req.setAttribute("errorMessage", "Failed to check in guest");
                    }
                    break;
                case "checkout":
                    if (checkOutBooking(req)) {
                        req.setAttribute("successMessage", "Guest checked out successfully!");
                    } else {
                        req.setAttribute("errorMessage", "Failed to check out guest");
                    }
                    break;
                case "cancel":
                    if (cancelBooking(req)) {
                        req.setAttribute("successMessage", "Booking cancelled successfully!");
                    } else {
                        req.setAttribute("errorMessage", "Failed to cancel booking");
                    }
                    break;
                case "update":
                    if (updateBooking(req)) {
                        req.setAttribute("successMessage", "Booking updated successfully!");
                    } else {
                        req.setAttribute("errorMessage", "Failed to update booking");
                    }
                    break;
                default:
                    req.setAttribute("errorMessage", "Invalid action: " + action);
            }
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database operation error: " + e.getMessage());
            e.printStackTrace();
        }

        // Forward back to bookings page instead of redirect
        doGet(req, resp);
    }

    private boolean createBooking(HttpServletRequest req, User user) throws SQLException {
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String idNumber = req.getParameter("idNumber");
        int roomId = Integer.parseInt(req.getParameter("roomId"));
        Date checkInDate = Date.valueOf(req.getParameter("checkInDate"));
        Date checkOutDate = Date.valueOf(req.getParameter("checkOutDate"));
        int adults = Integer.parseInt(req.getParameter("adults"));
        int children = Integer.parseInt(req.getParameter("children"));

        // Check if guest exists by phone
        int guestId = bookingDao.getGuestId(phone);
        if (guestId == -1) {
            // Create new guest
            bookingDao.createGuest(firstName, lastName, email, phone, idNumber);
            guestId = bookingDao.getGuestId(phone);
        }

        // Calculate total amount
        double totalAmount = bookingDao.calculateTotalAmount(roomId, checkInDate, checkOutDate);

        // Create booking with confirmed status
        boolean success = bookingDao.createBookingConfirmed(guestId, roomId, checkInDate, checkOutDate,adults, children, totalAmount, user.getUserId());

        if (success) {
            // Update room status to occupied
            bookingDao.updateRoomStatus(roomId, "occupied");
        }
        return success;
    }

    private boolean checkInBooking(HttpServletRequest req) throws SQLException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        return bookingDao.updateBookingStatus(bookingId, "checked_in");
    }

    private boolean checkOutBooking(HttpServletRequest req) throws SQLException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));

        // Get room ID for this booking
        int roomId = bookingDao.getRoomIdByBooking(bookingId);

        // Update booking status
        boolean success = bookingDao.updateBookingStatus(bookingId, "checked_out");

        if (roomId != -1) {
            // Update room status to available
            bookingDao.updateRoomStatus(roomId, "available");
        }
        return success;
    }

    private boolean cancelBooking(HttpServletRequest req) throws SQLException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));

        // Get room ID for this booking
        int roomId = bookingDao.getRoomIdByBooking(bookingId);

        // Update booking status
        boolean success = bookingDao.updateBookingStatus(bookingId, "cancelled");

        if (roomId != -1) {
            // Update room status to available
            bookingDao.updateRoomStatus(roomId, "available");
        }
        return success;
    }

    private boolean updateBooking(HttpServletRequest req) throws SQLException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        Date checkInDate = Date.valueOf(req.getParameter("checkInDate"));
        Date checkOutDate = Date.valueOf(req.getParameter("checkOutDate"));
        int adults = Integer.parseInt(req.getParameter("adults"));
        int children = Integer.parseInt(req.getParameter("children"));

        return bookingDao.updateBooking(bookingId, checkInDate, checkOutDate, adults, children);
    }
}
