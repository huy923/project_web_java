package com.example.servlet;

import com.example.dao.BookingDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "CheckOutServlet", urlPatterns = { "/checkout" })
public class CheckOutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        BookingDao dao = new BookingDao();
        try {
            req.setAttribute("occupiedRooms", dao.getOccupiedRooms());
            req.getRequestDispatcher("/modals/checkout.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        BookingDao dao = new BookingDao();

        try {
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
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
