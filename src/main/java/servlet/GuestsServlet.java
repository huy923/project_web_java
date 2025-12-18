package servlet;

import dao.GuestDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "GuestsServlet", urlPatterns = { "/guests" })
public class GuestsServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
            return;
        }

        try {
            GuestDao dao = new GuestDao();
            req.setAttribute("guests", dao.getAllGuests());
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Error loading guests: " + e.getMessage());
        }

        req.getRequestDispatcher("/sections/guests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAuthentication(req, resp)) {
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
                message = success ? "Guest added successfully" : "Failed to add guest";
            } else if ("update".equals(action)) {
                int guestId = Integer.parseInt(req.getParameter("guestId"));
                String firstName = req.getParameter("firstName");
                String lastName = req.getParameter("lastName");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String idNumber = req.getParameter("idNumber");
                String nationality = req.getParameter("nationality");

                success = dao.updateGuest(guestId, firstName, lastName, email, phone, idNumber, nationality);
                message = success ? "Guest updated successfully" : "Failed to update guest";
            } else if ("delete".equals(action)) {
                int guestId = Integer.parseInt(req.getParameter("guestId"));
                success = dao.deleteGuest(guestId);
                message = success ? "Guest deleted successfully" : "Failed to delete guest";
            }

            if (success) {
                req.setAttribute("successMessage", message);
            } else {
                req.setAttribute("errorMessage", message);
            }

            req.setAttribute("guests", dao.getAllGuests());

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid input: " + e.getMessage());
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        req.getRequestDispatcher("/sections/guests.jsp").forward(req, resp);
    }
}
