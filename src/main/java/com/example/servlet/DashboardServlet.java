package com.example.servlet;

import com.example.dao.DashboardDao;
import com.example.dao.BookingDao;
import com.example.dao.RoomDao;
import com.example.dao.GuestDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "DashboardServlet", urlPatterns = { "/dashboard" })
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        DashboardDao dao = new DashboardDao();
        BookingDao bookingDao = new BookingDao();
        RoomDao roomDao = new RoomDao();
        GuestDao guestDao = new GuestDao();
        try {
            req.setAttribute("roomStatus", dao.getCurrentRoomStatus());
            req.setAttribute("roomStats", dao.getRoomStatistics());
            req.setAttribute("totalBookings", dao.getTotalBookings());
            req.setAttribute("availableRooms", bookingDao.getAvailableRooms());
            req.setAttribute("occupiedRooms", bookingDao.getOccupiedRooms());
            req.setAttribute("rooms", roomDao.getAllRooms());
            req.setAttribute("roomTypes", roomDao.getRoomTypes());
            req.setAttribute("guests", guestDao.getAllGuests());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
