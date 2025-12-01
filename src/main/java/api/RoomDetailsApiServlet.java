package api;

import dao.RoomDao;
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
import java.util.Map;

@WebServlet(name = "RoomDetailsApiServlet", urlPatterns = { "/api/room-details" })
public class RoomDetailsApiServlet extends HttpServlet {

    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
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
            String roomIdStr = req.getParameter("roomId");

            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");

                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Room ID is required");

                PrintWriter out = resp.getWriter();
                out.print(gson.toJson(errorResponse));
                out.flush();
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            RoomDao dao = new RoomDao();
            Map<String, Object> roomDetails = dao.getRoomDetailsWithBooking(roomId);

            // Set response headers
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            resp.setHeader("Pragma", "no-cache");
            resp.setHeader("Expires", "0");

            if (roomDetails != null) {
                JsonObject response = new JsonObject();
                response.addProperty("success", true);
                response.add("data", gson.toJsonTree(roomDetails));

                PrintWriter out = resp.getWriter();
                out.print(gson.toJson(response));
                out.flush();
            } else {
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Room not found");

                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                PrintWriter out = resp.getWriter();
                out.print(gson.toJson(errorResponse));
                out.flush();
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Invalid room ID format");

            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(errorResponse));
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
