package api;

import dao.BookingDao;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "BookingApi", urlPatterns = {"/api/booking"})
public class BookingApi extends HttpServlet {
    private Gson gson = new Gson();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Unauthorized access");
            
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(errorResponse));
            out.flush();
            return;
        }
        
        try {
            BookingDao dao = new BookingDao();
            List<Map<String, Object>> booking = dao.getAllBookings();
            
            // Set response headers
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            resp.setHeader("Pragma", "no-cache");
            resp.setHeader("Expires", "0");
            
            // Tạo response JSON
            JsonObject response = new JsonObject();
            response.addProperty("success", true);
            response.addProperty("timestamp", System.currentTimeMillis());
            response.add("data", gson.toJsonTree(booking));
            
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(response));
            out.flush();
            
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Database error: " + e.getMessage());
            
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(errorResponse));
            out.flush();
        }
    }
}