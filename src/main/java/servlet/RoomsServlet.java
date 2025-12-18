package servlet;

import dao.RoomDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "RoomsServlet", urlPatterns = { "/rooms" })
public class RoomsServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }

        try {
            RoomDao dao = new RoomDao();
            req.setAttribute("rooms", dao.getAllRooms());
            req.setAttribute("roomTypes", dao.getRoomTypes());
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Error loading rooms: " + e.getMessage());
        }

        req.getRequestDispatcher("/sections/rooms.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }

        String action = req.getParameter("action");
        RoomDao dao = new RoomDao();

        try {
            boolean success = false;
            String message = "";

            if ("add".equals(action)) {
                String roomNumber = req.getParameter("roomNumber");
                int roomTypeId = Integer.parseInt(req.getParameter("roomTypeId"));
                int floorNumber = Integer.parseInt(req.getParameter("floorNumber"));
                success = dao.addRoom(roomNumber, roomTypeId, floorNumber);
                message = success ? "Room added successfully" : "Failed to add room";
            } else if ("updateStatus".equals(action)) {
                int roomId = Integer.parseInt(req.getParameter("roomId"));
                String status = req.getParameter("status");
                success = dao.updateRoomStatus(roomId, status);
                message = success ? "Room status updated" : "Failed to update room status";
            } else if ("delete".equals(action)) {
                int roomId = Integer.parseInt(req.getParameter("roomId"));
                success = dao.deleteRoom(roomId);
                message = success ? "Room deleted" : "Failed to delete room (may be occupied)";
            }

            if (success) {
                req.setAttribute("successMessage", message);
            } else {
                req.setAttribute("errorMessage", message);
            }

            req.setAttribute("rooms", dao.getAllRooms());
            req.setAttribute("roomTypes", dao.getRoomTypes());

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid input: " + e.getMessage());
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        req.getRequestDispatcher("/sections/rooms.jsp").forward(req, resp);
    }
}
