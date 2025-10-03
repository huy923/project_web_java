package com.example.servlet;

import com.example.dao.BookingDao;
import com.example.dao.RoomDao;
import com.example.dao.GuestDao;
import com.example.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "BookingsServlet", urlPatterns = {"/bookings"})
public class BookingsServlet extends HttpServlet {
    
    private BookingDao bookingDao = new BookingDao();
    private RoomDao roomDao = new RoomDao();
    private GuestDao guestDao = new GuestDao();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
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
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String action = req.getParameter("action");
        User user = (User) session.getAttribute("user");
        
        try {
            switch (action) {
                case "create":
                    createBooking(req, user);
                    break;
                case "checkin":
                    checkInBooking(req);
                    break;
                case "checkout":
                    checkOutBooking(req);
                    break;
                case "cancel":
                    cancelBooking(req);
                    break;
                case "update":
                    updateBooking(req);
                    break;
                default:
                    req.setAttribute("error", "Invalid action: " + action);
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Database operation error: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Redirect back to bookings page
        resp.sendRedirect(req.getContextPath() + "/bookings");
    }
    
    private void createBooking(HttpServletRequest req, User user) throws SQLException {
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
        String notes = req.getParameter("notes");
        
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
        boolean success = bookingDao.createBookingConfirmed(guestId, roomId, checkInDate, checkOutDate,
                adults, children, totalAmount, notes, user.getUserId());
        
        if (success) {
            // Update room status to occupied
            bookingDao.updateRoomStatus(roomId, "occupied");
        }
    }
    
    private void checkInBooking(HttpServletRequest req) throws SQLException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        bookingDao.updateBookingStatus(bookingId, "checked_in");
    }
    
    private void checkOutBooking(HttpServletRequest req) throws SQLException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        
        // Get room ID for this booking
        int roomId = bookingDao.getRoomIdByBooking(bookingId);
        
        // Update booking status
        bookingDao.updateBookingStatus(bookingId, "checked_out");
        
        if (roomId != -1) {
            // Update room status to available
            bookingDao.updateRoomStatus(roomId, "available");
        }
    }
    
    private void cancelBooking(HttpServletRequest req) throws SQLException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        
        // Get room ID for this booking
        int roomId = bookingDao.getRoomIdByBooking(bookingId);
        
        // Update booking status
        bookingDao.updateBookingStatus(bookingId, "cancelled");
        
        if (roomId != -1) {
            // Update room status to available
            bookingDao.updateRoomStatus(roomId, "available");
        }
    }
    
    private void updateBooking(HttpServletRequest req) throws SQLException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        Date checkInDate = Date.valueOf(req.getParameter("checkInDate"));
        Date checkOutDate = Date.valueOf(req.getParameter("checkOutDate"));
        int adults = Integer.parseInt(req.getParameter("adults"));
        int children = Integer.parseInt(req.getParameter("children"));
        String notes = req.getParameter("notes");
        
        bookingDao.updateBooking(bookingId, checkInDate, checkOutDate, adults, children, notes);
    }
}


