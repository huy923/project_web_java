package servlet;

import dao.ReviewDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/reviews")
public class ReviewsServlet extends BaseServlet {
    private ReviewDao reviewDao = new ReviewDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuthentication(request, response)) {
            return;
        }

        try {
            String action = request.getParameter("action");

            if (action == null) {
                // Display all reviews
                List<Map<String, Object>> reviews = reviewDao.getAllReviews();
                request.setAttribute("reviews", reviews);
                double avgRating = reviewDao.getAverageRating();
                request.setAttribute("avgRating", Math.round(avgRating * 10.0) / 10.0);
                request.getRequestDispatcher("/sections/reviews.jsp").forward(request, response);
            } else if ("view".equals(action)) {
                // View single review
                int reviewId = Integer.parseInt(request.getParameter("id"));
                Map<String, Object> review = reviewDao.getReviewById(reviewId);
                request.setAttribute("review", review);
                request.getRequestDispatcher("/sections/reviews.jsp").forward(request, response);
            } else if ("public".equals(action)) {
                // Show public reviews only
                List<Map<String, Object>> reviews = reviewDao.getPublicReviews();
                request.setAttribute("reviews", reviews);
                request.setAttribute("filterPublic", true);
                double avgRating = reviewDao.getAverageRating();
                request.setAttribute("avgRating", Math.round(avgRating * 10.0) / 10.0);
                request.getRequestDispatcher("/sections/reviews.jsp").forward(request, response);
            } else if ("byRating".equals(action)) {
                // Filter by rating
                int minRating = Integer.parseInt(request.getParameter("minRating"));
                int maxRating = Integer.parseInt(request.getParameter("maxRating"));
                List<Map<String, Object>> reviews = reviewDao.getReviewsByRating(minRating, maxRating);
                request.setAttribute("reviews", reviews);
                request.setAttribute("filterRating", minRating + " - " + maxRating);
                request.getRequestDispatcher("/sections/reviews.jsp").forward(request, response);
            } else if ("distribution".equals(action)) {
                // Get rating distribution
                Map<Integer, Integer> distribution = reviewDao.getRatingDistribution();
                request.setAttribute("ratingDistribution", distribution);
                double avgRating = reviewDao.getAverageRating();
                request.setAttribute("avgRating", Math.round(avgRating * 10.0) / 10.0);
                request.getRequestDispatcher("/sections/reviews.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading reviews: " + e.getMessage());
            try {
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuthentication(request, response)) {
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("add".equals(action)) {
                // Add new review
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String title = request.getParameter("title");
                String comment = request.getParameter("comment");
                boolean isPublic = "on".equals(request.getParameter("isPublic"));

                boolean success = reviewDao.addReview(bookingId, rating, title, comment, isPublic);

                if (success) {
                    request.setAttribute("successMessage", "Review added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add review");
                }

                doGet(request, response);
            } else if ("update".equals(action)) {
                // Update review
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String title = request.getParameter("title");
                String comment = request.getParameter("comment");
                boolean isPublic = "on".equals(request.getParameter("isPublic"));

                boolean success = reviewDao.updateReview(reviewId, rating, title, comment, isPublic);

                if (success) {
                    request.setAttribute("successMessage", "Review updated successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to update review");
                }

                doGet(request, response);
            } else if ("toggleVisibility".equals(action)) {
                // Toggle public/private
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));

                boolean success = reviewDao.toggleReviewVisibility(reviewId);

                if (success) {
                    request.setAttribute("successMessage", "Review visibility toggled");
                } else {
                    request.setAttribute("errorMessage", "Failed to toggle visibility");
                }

                doGet(request, response);
            } else if ("delete".equals(action)) {
                // Delete review
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));

                boolean success = reviewDao.deleteReview(reviewId);

                if (success) {
                    request.setAttribute("successMessage", "Review deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete review");
                }

                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid input format: " + e.getMessage());
            try {
                doGet(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            try {
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        }
    }
}
