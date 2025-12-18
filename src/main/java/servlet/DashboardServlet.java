package servlet;

import dao.DashboardDao;
import dao.BookingDao;
import dao.RoomDao;
import dao.GuestDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "DashboardServlet", urlPatterns = { "/dashboard" })
public class DashboardServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }
        DashboardDao dao = new DashboardDao();
        BookingDao bookingDao = new BookingDao();
        RoomDao roomDao = new RoomDao();
        GuestDao guestDao = new GuestDao();
        try {
            // Room status is now loaded via AJAX, so we don't need to load it here
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
