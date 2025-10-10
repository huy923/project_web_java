package servlet;

import dao.RoomDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "RoomManagementServlet", urlPatterns = { "/room-management" })
public class RoomManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        RoomDao dao = new RoomDao();
        try {
            req.setAttribute("rooms", dao.getAllRooms());
            req.setAttribute("roomTypes", dao.getRoomTypes());
            req.getRequestDispatcher("/modals/room-management.jsp").forward(req, resp);
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
                message = success ? "Phòng đã được thêm thành công" : "Không thể thêm phòng";
            } else if ("updateStatus".equals(action)) {
                int roomId = Integer.parseInt(req.getParameter("roomId"));
                String status = req.getParameter("status");
                success = dao.updateRoomStatus(roomId, status);
                message = success ? "Trạng thái phòng đã được cập nhật" : "Không thể cập nhật trạng thái";
            } else if ("delete".equals(action)) {
                int roomId = Integer.parseInt(req.getParameter("roomId"));
                success = dao.deleteRoom(roomId);
                message = success ? "Phòng đã được xóa" : "Không thể xóa phòng (có thể đang có khách)";
            }

            req.setAttribute("message", message);
            req.setAttribute("success", success);
            req.setAttribute("rooms", dao.getAllRooms());
            req.setAttribute("roomTypes", dao.getRoomTypes());
            req.getRequestDispatcher("/modals/room-management.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
