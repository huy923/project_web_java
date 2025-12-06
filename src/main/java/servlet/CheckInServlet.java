package servlet;

import dao.BookingDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet(name = "CheckInServlet", urlPatterns = { "/check-in" })
public class CheckInServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/sections/check-in.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String idNumber = req.getParameter("idNumber");

            // Validate required parameters
            if (firstName == null || firstName.trim().isEmpty() ||
                    lastName == null || lastName.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    idNumber == null || idNumber.trim().isEmpty()) {
                req.setAttribute("errorMessage", "All fields are required");
                doGet(req, resp);
                return;
            }

            String roomIdStr = req.getParameter("roomId");
            String checkInDateStr = req.getParameter("checkInDate");
            String checkOutDateStr = req.getParameter("checkOutDate");
            String adultsStr = req.getParameter("adults");
            String childrenStr = req.getParameter("children");
            String totalAmountStr = req.getParameter("totalAmount");

            // Validate numeric parameters
            if (roomIdStr == null || roomIdStr.trim().isEmpty() ||
                    checkInDateStr == null || checkInDateStr.trim().isEmpty() ||
                    checkOutDateStr == null || checkOutDateStr.trim().isEmpty() ||
                    adultsStr == null || adultsStr.trim().isEmpty() ||
                    totalAmountStr == null || totalAmountStr.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Please fill in all required fields");
                doGet(req, resp);
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            Date checkInDate = Date.valueOf(checkInDateStr);
            Date checkOutDate = Date.valueOf(checkOutDateStr);
            int adults = Integer.parseInt(adultsStr);
            int children = Integer.parseInt(childrenStr == null || childrenStr.isEmpty() ? "0" : childrenStr);
            double totalAmount = Double.parseDouble(totalAmountStr);

            User user = (User) session.getAttribute("user");
            BookingDao dao = new BookingDao();

            // Check if guest exists by phone
            int guestId = dao.getGuestId(phone);
            if (guestId == -1) {
                // Create new guest
                dao.createGuest(firstName, lastName, email == null ? "" : email, phone, idNumber);
                guestId = dao.getGuestId(phone);
            }

            // Create booking
            boolean success = dao.createBooking(guestId, roomId, checkInDate, checkOutDate,adults, children, totalAmount, user.getUserId());

            if (success) {
                // Update room status to occupied
                dao.updateRoomStatus(roomId, "occupied");
                resp.sendRedirect(req.getContextPath() + "/dashboard?success=checkin");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard?error=checkin");
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD");
            doGet(req, resp);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
