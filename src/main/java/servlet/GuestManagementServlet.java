package servlet;

import dao.GuestDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "GuestManagementServlet", urlPatterns = { "/guest-management" })
public class GuestManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        GuestDao dao = new GuestDao();
        try {
            req.setAttribute("guests", dao.getAllGuests());
            req.getRequestDispatcher("/modals/guest-management.jsp").forward(req, resp);
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
        GuestDao dao = new GuestDao();

        try {
            boolean success = false;
            String message = "";

            if ("add".equals(action)) {
                String firstName = req.getParameter("firstName");
                String lastName = req.getParameter("lastName");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String idNumber = req.getParameter("idNumber");
                String nationality = req.getParameter("nationality");
                success = dao.addGuest(firstName, lastName, email, phone, idNumber, nationality);
                message = success ? "Khách hàng đã được thêm thành công" : "Không thể thêm khách hàng";
            } else if ("update".equals(action)) {
                int guestId = Integer.parseInt(req.getParameter("guestId"));
                String firstName = req.getParameter("firstName");
                String lastName = req.getParameter("lastName");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String idNumber = req.getParameter("idNumber");
                String nationality = req.getParameter("nationality");
                success = dao.updateGuest(guestId, firstName, lastName, email, phone, idNumber, nationality);
                message = success ? "Thông tin khách hàng đã được cập nhật" : "Không thể cập nhật thông tin";
            } else if ("delete".equals(action)) {
                int guestId = Integer.parseInt(req.getParameter("guestId"));
                success = dao.deleteGuest(guestId);
                message = success ? "Khách hàng đã được xóa" : "Không thể xóa khách hàng (có đặt phòng đang hoạt động)";
            }

            req.setAttribute("message", message);
            req.setAttribute("success", success);
            req.setAttribute("guests", dao.getAllGuests());
            req.getRequestDispatcher("/modals/guest-management.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
