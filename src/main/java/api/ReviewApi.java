package api;

import dao.ReviewDao;
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

@WebServlet(name = "ReviewApi", urlPatterns = {"/api/reviews", "/api/review/*"})
public class ReviewApi extends HttpServlet {
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            String pathInfo = req.getPathInfo();
            String publicOnly = req.getParameter("public");
            String minRating = req.getParameter("min_rating");
            String maxRating = req.getParameter("max_rating");
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/reviews - Get all reviews
                if (publicOnly != null && publicOnly.equals("true")) {
                    getPublicReviews(req, resp);
                } else if (minRating != null && maxRating != null) {
                    getReviewsByRating(req, resp, Integer.parseInt(minRating), Integer.parseInt(maxRating));
                } else {
                    getAllReviews(req, resp);
                }
            } else {
                // GET /api/review/{id} - Get review by ID
                String[] parts = pathInfo.split("/");
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    int reviewId = Integer.parseInt(parts[1]);
                    getReviewById(req, resp, reviewId);
                } else {
                    sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid review ID");
                }
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            // Parse JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            
            int bookingId = json.has("booking_id") ? json.get("booking_id").getAsInt() : 0;
            int guestId = json.has("guest_id") ? json.get("guest_id").getAsInt() : 0;
            int rating = json.has("rating") ? json.get("rating").getAsInt() : 0;
            String reviewText = json.has("review_text") ? json.get("review_text").getAsString() : "";
            boolean isPublic = json.has("is_public") ? json.get("is_public").getAsBoolean() : false;

            if (bookingId == 0 || guestId == 0 || rating == 0 || rating < 1 || rating > 5) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields or invalid rating");
                return;
            }

            ReviewDao dao = new ReviewDao();
            boolean success = dao.addReview(bookingId, guestId, rating, reviewText, isPublic);

            if (success) {
                sendSuccessResponse(resp, "Review added successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add review");
            }
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            String pathInfo = req.getPathInfo();
            String[] parts = pathInfo.split("/");
            
            if (parts.length <= 1 || parts[1].isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Review ID required");
                return;
            }

            int reviewId = Integer.parseInt(parts[1]);

            // Parse JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            
            Integer rating = json.has("rating") ? json.get("rating").getAsInt() : null;
            String reviewText = json.has("review_text") ? json.get("review_text").getAsString() : null;
            Boolean isPublic = json.has("is_public") ? json.get("is_public").getAsBoolean() : null;
            Boolean toggleVisibility = json.has("toggle_visibility") ? json.get("toggle_visibility").getAsBoolean() : null;

            ReviewDao dao = new ReviewDao();
            boolean success = false;

            if (toggleVisibility != null && toggleVisibility) {
                success = dao.toggleReviewVisibility(reviewId);
            } else if (rating != null && reviewText != null && isPublic != null) {
                success = dao.updateReview(reviewId, rating, reviewText, isPublic);
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid update parameters");
                return;
            }

            if (success) {
                sendSuccessResponse(resp, "Review updated successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update review");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid review ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }

        try {
            String pathInfo = req.getPathInfo();
            String[] parts = pathInfo.split("/");
            
            if (parts.length <= 1 || parts[1].isEmpty()) {
                sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Review ID required");
                return;
            }

            int reviewId = Integer.parseInt(parts[1]);

            ReviewDao dao = new ReviewDao();
            boolean success = dao.deleteReview(reviewId);

            if (success) {
                sendSuccessResponse(resp, "Review deleted successfully");
            } else {
                sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete review");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_BAD_REQUEST, "Invalid review ID format");
        } catch (SQLException e) {
            sendErrorResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void getAllReviews(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        ReviewDao dao = new ReviewDao();
        List<Map<String, Object>> reviews = dao.getAllReviews();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(reviews));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getPublicReviews(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        ReviewDao dao = new ReviewDao();
        List<Map<String, Object>> reviews = dao.getPublicReviews();

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(reviews));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getReviewsByRating(HttpServletRequest req, HttpServletResponse resp, int minRating, int maxRating) throws SQLException, IOException {
        ReviewDao dao = new ReviewDao();
        List<Map<String, Object>> reviews = dao.getReviewsByRating(minRating, maxRating);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("timestamp", System.currentTimeMillis());
        response.add("data", gson.toJsonTree(reviews));

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void getReviewById(HttpServletRequest req, HttpServletResponse resp, int reviewId) throws SQLException, IOException {
        ReviewDao dao = new ReviewDao();
        Map<String, Object> review = dao.getReviewById(reviewId);

        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", review != null);
        response.addProperty("timestamp", System.currentTimeMillis());
        
        if (review != null) {
            response.add("data", gson.toJsonTree(review));
        } else {
            response.addProperty("message", "Review not found");
        }

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void sendSuccessResponse(HttpServletResponse resp, String message) throws IOException {
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", true);
        response.addProperty("message", message);
        response.addProperty("timestamp", System.currentTimeMillis());

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void sendErrorResponse(HttpServletResponse resp, int status, String message) throws IOException {
        resp.setStatus(status);
        setResponseHeaders(resp);
        JsonObject response = new JsonObject();
        response.addProperty("success", false);
        response.addProperty("message", message);
        response.addProperty("timestamp", System.currentTimeMillis());

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private void setResponseHeaders(HttpServletResponse resp) {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Expires", "0");
    }
}
