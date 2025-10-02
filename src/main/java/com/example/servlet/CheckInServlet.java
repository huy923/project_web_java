package com.example.servlet;

import com.example.dao.BookingDao;
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

@WebServlet(name = "CheckInServlet", urlPatterns = { "/checkin" })
public class CheckInServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        BookingDao dao = new BookingDao();
        try {
            req.setAttribute("availableRooms", dao.getAvailableRooms());
            req.getRequestDispatcher("/modals/checkin.jsp").forward(req, resp);
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
        double totalAmount = Double.parseDouble(req.getParameter("totalAmount"));

        User user = (User) session.getAttribute("user");
        BookingDao dao = new BookingDao();

        try {
            // Check if guest exists by phone
            int guestId = dao.getGuestId(phone);
            if (guestId == -1) {
                // Create new guest
                dao.createGuest(firstName, lastName, email, phone, idNumber);
                guestId = dao.getGuestId(phone);
            }

            // Create booking
            boolean success = dao.createBooking(guestId, roomId, checkInDate, checkOutDate,
                    adults, children, totalAmount, user.getUserId());

            if (success) {
                // Update room status to occupied
                dao.updateRoomStatus(roomId, "occupied");
                resp.sendRedirect(req.getContextPath() + "/dashboard?success=checkin");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard?error=checkin");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
