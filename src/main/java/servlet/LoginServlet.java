package servlet;

import dao.UserDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        UserDao userDao = new UserDao();
        try {
            User user = userDao.findByUsername(username);
            if (user != null && user.isActive() && userDao.validatePassword(password, user.getPasswordHash())) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } else {
                req.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
