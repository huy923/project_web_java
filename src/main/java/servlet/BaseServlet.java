package servlet;

import util.CookieUtil;
import dao.UserDao;
import model.User;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class BaseServlet extends HttpServlet {

    protected boolean checkAuthentication(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer userId = CookieUtil.getUserIdFromCookie(req);

        if (!CookieUtil.hasValidCookie(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            try {
                UserDao userDao = new UserDao();
                User user = userDao.findByUserId(userId);
                if (user != null) {
                    session = req.getSession(true);
                    session.setAttribute("user", user);
                    return true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }

        return true;
    }

    protected User getCurrentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
}
